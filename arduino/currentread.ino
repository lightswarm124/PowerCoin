long randNumber;
void setup() {
  Serial.begin(9600);
  randomSeed(analogRead(0));
}
void loop() {
  int volts = random(50);
  int watts = random(50);
  int amps = (watts/volts);
  Serial.print(volts);
  Serial.print("\t");
  Serial.print(watts);
  Serial.print("\t");
  Serial.print(amps);
  Serial.print("\t");
  Serial.print("\n");
  delay(10000);
 }
