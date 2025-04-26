import kivy
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.image import Image

class SpartanApp(App):

    def build(self):

        img = Image(source=r"C:\Users\khait\Downloads\download.jpeg")
        return img    

if __name__ == "__main__":
    SpartanApp().run()