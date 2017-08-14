import libvirt
from libvirt import libvirtError

def create():
    '''
    Create libvirt/kvm pool.

    CLI Example:
    .. code-block:: bash
        salt '*' kvm_pool.create
    '''

    xmlDesc = """
    <pool type='dir'>
      <name>default</name>
      <target>
        <path>/var/lib/libvirt/images</path>
      </target>
    </pool>"""
    
    try: 
        conn = libvirt.open('qemu:///system')
    except:
        print('Failed to open connection to qemu:///system')
    
    try:
        pool = conn.storagePoolLookupByName("default")
        print("Pool already exist")
    except libvirtError:
        pool = conn.storagePoolDefineXML(xmlDesc, 0)
        print("New pool was created")
    if not pool.autostart():
        pool.setAutostart(1)
    if not pool.isActive():
        pool.create()
    
    conn.close()
    
    return True
