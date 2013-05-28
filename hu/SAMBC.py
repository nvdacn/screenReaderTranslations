import appModuleHandler
import NVDAObjects.IAccessible
from NVDAObjects.IAccessible import sysListView32

class AppModule(appModuleHandler.AppModule):

    def chooseNVDAObjectOverlayClasses(self, obj, clsList):
        if obj.name == None and object.role == controlTypes.ROLE_UNKNOWN:
            clsList.insert(0, Display)

class Display(NVDAObjects.IAccessible.IAccessible):

    shouldAllowIAccessibleFocusEvent=True
    def _get_name(self):
        name=super(Display,self).name
        if not name:
            name=_("Display")
        return name
