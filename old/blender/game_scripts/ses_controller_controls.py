from bge import logic, events

def movement():
    scene = logic.getCurrentScene()
    controller = logic.getCurrentController()
    obj = controller.owner
    sensor = obj.sensors['ses_controller']
    
    if('ses_controller' not in controller.owner.sensors):
        print(obj.name, 'only has these sensors attached', controller.owner.sensors)
        return

    sensor = controller.owner.sensors['ses_controller']

    '''
    A mouse movement sensor makes these attributes available
    ['executePriority', 'frequency', 'getButtonStatus', 'invalid', 
    'invert', 'level', 'mode', 'name', 'neg_ticks', 'owner', 
    'pos_ticks', 'position', 'positive', 'reset', 'skippedTicks', 'status', 'tap', 'triggered', 'useNegPulseMode', 'usePosPulseMode']
    '''

    x, y = sensor.position
    
    if(x < tracker.last_x):
        obj.position.x -= 0.1
    elif(x > tracker.last_x):
        obj.position.x += 0.1  
    elif(y < tracker.last_y):
        obj.position.y -= 0.1
    elif(y > tracker.last_y):
        obj.position.y += 0.1             
        
           


    '''
    notice the mouse stops at the edge of the screen...
    how can you use an offset to fix this?
    '''
    
    # docs for the mouse status codes are at https://www.blender.org/api/blender_python_api_2_65a_release/bge.events.html#mouse-keys
    lb_state = sensor.getButtonStatus(events.LEFTMOUSE)
    mb_state = sensor.getButtonStatus(events.MIDDLEMOUSE)
    rb_state = sensor.getButtonStatus(events.RIGHTMOUSE)
    
    print('mouse button states', lb_state, mb_state, rb_state)
    
    tracker.update(x,y)

# this is an object to manage the mouse state    
class Tracker():
    def __init__(self):
        self.last_x = 0
        self.last_y = 0
    
    def update(self, x, y):
        self.last_x = x;
        self.last_y = y;

# start it in the main function and invoke the other functions as modules
tracker = Tracker()    

