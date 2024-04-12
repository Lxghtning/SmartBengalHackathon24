
class help_func{

List? yearOfGradDropDown(){
  DateTime dateTime = DateTime.now();
  int year = dateTime.year;
  List<int> years = [];
  for(int i = 0; i < 7; i++){
    years.add(year + i);
  }
  return years;
}

}