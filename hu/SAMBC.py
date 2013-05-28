import appModuleHandler
import NVDAObjects.IAccessible
class AppModule(appModuleHandler.AppModule):

	def chooseNVDAObjectOverlayClasses(self, obj, clsList):
		windowClassName=obj.windowClassName
		windowControlID=obj.windowControlID
        if windowClassName=="u'TVirtualSongTree'":
			clsList.insert(0, Display)

class Display(NVDAObjects.IAccessible.IAccessible):

	shouldAllowIAccessibleFocusEvent=True
	def _get_name(self):
		name=super(Display,self).name
		if not name:
			name=_("Display")
		return name
