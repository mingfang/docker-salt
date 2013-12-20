# -*- coding: utf-8 -*-
'''
Support for the Docker Command Line
'''

import salt.utils
from salt.exceptions import CommandExecutionError
import yaml
import os
import logging

def __virtual__():
    '''
    Only load if docker exists on the system
    '''
    if salt.utils.which('docker'):
        return 'dockercmd'
    return False

log = logging.getLogger(__name__)

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

def images():
    return __salt__['cmd.run']('docker images')

def inspect(name):
    run_all = __salt__['cmd.run_all']
    result = run_all('docker inspect ' + name, quiet=True)
    if result['retcode'] == 0:
        stdout = result['stdout']
        _yaml = yaml.safe_load(stdout)
        return _yaml[0]
    else:
        return result

def kill(name):
    return __salt__['cmd.run_all']('docker kill ' + name)

def rm(name):
    return __salt__['cmd.run_all']('docker rm ' + name)

def rmi(name):
    return __salt__['cmd.run_all']('docker rmi ' + name)

def run(name, image, ports=None, volumes=None, **kwargs):
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

# def save(name, dir, **kwargs):
#     run_all = __salt__['cmd.run_all']
#     # cmd = ['docker', 'save', name, '>', name + '.tar']
#     cmd = 'docker save %s > %s.tar' % (name, name)
#     log.info('cmd=' + cmd)
#     return run_all(cmd, cwd=dir, env=kwargs.get('env'), python_shell=False)
