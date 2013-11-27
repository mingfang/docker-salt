# -*- coding: utf-8 -*-
'''
Support for the Docker Command Line
'''

import salt.utils
from salt.exceptions import CommandExecutionError
import yaml
import os

def __virtual__():
    '''
    Only load if docker exists on the system
    '''
    if salt.utils.which('docker'):
        return 'dockercmd'
    return False


def version():
    '''
    Return the result of docker version command
    '''

    return __salt__['cmd.run']('docker version')

def ps(all=None):
    if all == 'all':
        return __salt__['cmd.run']('docker ps -a')
    else:
        return __salt__['cmd.run']('docker ps')

def info():
    return __salt__['cmd.run']('docker info')

def run(name, image, ports=None, volumes=None, reload=False, **kwargs):
    if name == image:
        raise CommandExecutionError('Container name must be different from image')
    _name = ['-name', name]
    _ports = []
    _volumes = []
    run_all = __salt__['cmd.run_all']

    #parse ports
    if ports is not None:
        for p in ports:
            _ports.extend(['-p', p])

    #parse volumes
    if volumes is not None:
        for v in volumes:
            _volumes.extend(['-v', v])
            
    #kill existing container
    result = run_all('docker inspect ' + name, quiet=True)
    if result['retcode'] == 0:
        if not reload:
            return 'A container with name="%s" already exist.' % (name)
        else:
            stdout = result['stdout']
            _yaml = yaml.safe_load(stdout)
            #upper case ID is for running container
            id = _yaml[0]['ID']
            run_all('docker kill ' + id)
            run_all('docker rm ' + id)

    #build and run cmd
    cmd = ['docker', 'run', '-d']
    cmd.extend(_name)
    cmd.extend(_ports)
    cmd.extend(_volumes)
    cmd.append(image)
    return run_all(cmd, env=kwargs.get('env'), python_shell=False)

def build(name, dir, nocache=False, **kwargs):
    run_all = __salt__['cmd.run_all']

    cmd = ['docker', 'build']
    if nocache:
        cmd.append('--no-cache')
    cmd.extend(['-t', name])
    cmd.append(dir)
    return run_all(cmd, cwd=dir, env=kwargs.get('env'), python_shell=False)