"""
Add a Collision shortcut button to the right-click menu (Nautilus GTK4)
"""

from subprocess import Popen, check_call, CalledProcessError
from urllib.parse import urlparse, unquote
from shutil import which
from gi import require_version
from gettext import textdomain, gettext

textdomain('dev.geopjr.Collision')
_ = gettext

require_version('Gtk', '4.0')
try:
    require_version('Nautilus', '4.1')
except ValueError:
    # Fallback if only Nautilus 4.0 exists
    require_version('Nautilus', '4.0')

from gi.repository import Nautilus, GObject, Gtk, Gdk

def get_collision():
    try:
        check_call("flatpak list --columns=application | grep \"dev.geopjr.Collision\" &> /dev/null", shell=True)
        return "flatpak run --file-forwarding dev.geopjr.Collision"
    except CalledProcessError:
        if which("collision") is not None:
            return "collision"
        else:
            return False

class NautilusCollision(Nautilus.MenuProvider, GObject.GObject):
    collision = get_collision()

    def __init__(self):
        self.window = None
        return
    
    # Executed method when the right-click entry is clicked
    def openWithCollision(self, menu, files):
        for file in files:
            file_path = repr(unquote(urlparse(file.get_uri()).path))
            if self.collision != "collision":
                file_path = "@@ " + file_path + " @@"
            Popen(self.collision + " " + file_path, shell=True)  # Collision need to be in your PATH
    
    def get_background_items(self, files):
        return

    def get_file_items(self, files):
        # The option doesn't appear when a folder is selected
        if any(x.is_directory() for x in files) or self.collision == False: 
            return ()

        menu_item = Nautilus.MenuItem(
                        name="NautilusCollision::CheckHashes",
                        label=_("Check Hashes"))

        menu_item.connect('activate', self.openWithCollision, files)

        return menu_item,
