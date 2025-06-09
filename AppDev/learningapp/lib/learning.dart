
enum PlanetType {
  terrestrial("terrestrial"),
  gas("gas"), 
  ice("ice");
  
  final String name;

  const PlanetType(
    this.name,
  );
  
}

enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ···
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// A constant generating constructor
  const Planet({
    required this.planetType,
    required this.moons,
    required this.hasRings,
  });

  /// All instance variables are final
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enhanced enums support getters and other methods
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}



void main(){
  var name = 'Voyager I';
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  flybyObjects.where((name) => name.contains('turn')).forEach(print);
  final yourPlanet = Planet.uranus;
  String Pname = yourPlanet.planetType.name;
  if(!yourPlanet.isGiant) {
    print('Your planet is a $Pname planet which is not "giant planet".');
  }else{
    print('Your planet is a $Pname planet which is a "giant planet".');
  }
}
