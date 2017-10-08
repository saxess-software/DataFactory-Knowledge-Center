1. delete the first row
2. Replace the Column Labels
  * Jan/2016 -> 2016-01
  * Feb/2016 -> 2016-02
  * Mrz/2016 -> 2016-03 
  * .....
  * Dez/2016 -> 2016-12
  * EB-Wert -> 2016-0
  * Gesamtsaldo -> 2016-13
3. adjust the Value, based on the two columns on the right, if the second of them contains a "H", take the value * -1
4. delete the columns with S,H
5. Insert the data into the target format, use the file name as column "CompanyName"
