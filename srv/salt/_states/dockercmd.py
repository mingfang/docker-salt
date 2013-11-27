import salt.utils
from salt.exceptions import CommandExecutionError

def __virtual__():
    '''
    Only load if docker exists on the system
    '''
    if salt.utils.which('docker'):
        return 'dockercmd'
    return False

retPrototype = {
    'name':None,
    'changes':{},
    'result':None,
    'comment':None
}

def running(name,
            image,
            ports=None,
            volumes=None,
            reload=False,
            **kwargs):
    ret = retPrototype.copy()
    ret['name'] = name
    try:
        result = __salt__['dockercmd.run'](name, image, ports, volumes, reload)
        ret['result'] = True
        if isinstance(result, dict):
            ret['changes'] = result
        else:
            ret['comment'] = result
    except CommandExecutionError as ex:
        ret['result'] = False
        ret['comment'] = str(ex)
    return ret

def built(name,
          dockerfile,
          nocache=False,
          force=False):
    ret = retPrototype.copy()
    ret['name'] = name
    result = __salt__['dockercmd.build'](name, dockerfile, nocache)
    stderr = result['stderr']
    print stderr
    if 'Successfully built' in result['stdout']:
        ret['result'] = True
        ret['comment'] = stderr
    else:
        ret['result'] = False
        ret['changes'] = result
    return ret

def mod_watch(name, **kwargs):
    if kwargs['sfun'] == 'running':
        return running(name, reload=True, **kwargs)
    elif kwargs['sfun'] == 'built':
        return built(name, **kwargs)
