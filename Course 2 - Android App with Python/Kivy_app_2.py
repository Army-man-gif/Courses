import kivy
from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
class SpartanGrid(GridLayout):

    def __init__(self,**kwargs):
        super(SpartanGrid, self).__init__()
        self.cols = 
        self.add_widget(Label(text="Student Name: "))

        self.s_name = TextInput(multiline=True)
        self.add_widget(self.s_name)

        self.add_widget(Label(text="Student Marks: "))
        self.s_marks = TextInput(multiline=True)
        self.add_widget(self.s_marks)

        self.add_widget(Label(text="Student Gender"))
class SpartanApp(App):
    def build(self):
        return SpartanGrid()
    

if __name__ == "__main__":
    SpartanApp().run()