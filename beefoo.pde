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

void setup() {
  
  size(1600, 800);
  
  println("loading");
  
  lines = loadStrings("lines.csv");
  
  data = new Table();
  data.addColumn("words");
  data.addColumn("status");

  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
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
  }
  
  println(lines.length + " total rows in table"); 
}

void draw() {
  background(255);
  fill(palette[0]);
  rect(100,100,10,10);
}