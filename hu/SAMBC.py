import appModuleHandler
import NVDAObjects.IAccessible
from NVDAObjects.IAccessible import sysListView32

class AppModule(appModuleHandler.AppModule):

    def chooseNVDAObjectOverlayClasses(self, obj, clsList):
        windowClassName=obj.windowClassName
        windowControlID=obj.windowControlID
        if windowClassName=="u'TVirtualSongTree'":
            obj.role=controlTypes.ROLE_LISTITEM
            clsList.insert(0, sysListView32.ListItem))

class Display(NVDAObjects.IAccessible.IAccessible):

    shouldAllowIAccessibleFocusEvent=True
    def _get_name(self):
        name=super(Display,self).name
        if not name:
            name=_("Display")
        return name
