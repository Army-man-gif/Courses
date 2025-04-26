import kivy
from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
class SpartanGrid(App):

    def build(self):

        return Label(text="This is sparta!!!!")
    

if __name__ == "__main__":
    SpartanApp().run()