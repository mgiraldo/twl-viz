String[] lines;
Table data;
int letterSize = 4; // pixels
color[] palette = {
  #a6cee3,
  #1f78b4,
  #b2df8a,
  #33a02c
};

int currentTranscript = 0;
int currentLine = 0;
int columnWidth = 200;
int margin = 50;
int currentX = 0;
int currentY = 0;

void setup() {
  size(1600, 800);
  background(255);
  
  println("loading");
  
  lines = loadStrings("lines.csv");
  
  data = new Table();
  data.addColumn("words");
  data.addColumn("status");

  println(lines.length + " total rows in table"); 
}

void draw() {
  String line = lines[currentLine];
  String row[] = line.split(";");
  int id = int(row[0]);
  int sequence = int(row[3]);
  int status = int(row[4]);
  String text = row[2];
  TableRow dataRow = data.addRow();
  dataRow.setInt("status", status);
  String words[] = text.split(" ");
  String countStrings = "";
  int counts[] = new int[words.length];
  for (int j = 0; j < words.length; j++) {
    counts[j] = words[j].length();
  }
  countStrings = counts.toString();
  dataRow.setString("words", text);
  fill(palette[0]);
  rect(100,100,10,10);
  
  if (currentLine < lines.length - 1) {
    currentLine = currentLine + 1;
  }
}