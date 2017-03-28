String[] lines;
int letterSize = 1; // pixels
color[] palette = {
  #7fc97f,
  #beaed4,
  #fdc086,
  #ffff99,
  #386cb0
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
  noStroke();

  println("loading");
  
  lines = loadStrings("lines.csv");
  
  println(lines.length + " total rows in table");
  
  currentX = margin;
  currentY = margin;
}

void draw() {
  String line = lines[currentLine];
  String row[] = line.split(",");
  int id = int(row[0]);
  int sequence = int(row[1]);
  int status = int(row[4]);
  String text = row[3].equals("\"\"") ? row[2] : row[3];
  text = text.replaceAll("\"", "");
  String words[] = text.split(" ");

  fill(palette[status]);

  for (int j = 0; j < words.length; j++) {
    int count = words[j].length();
    rect(currentX, currentY, count * letterSize, letterSize);
    
    currentX = currentX + count * letterSize;
    
    if (j+1 < words.length && currentX > margin) {
      currentX = currentX + letterSize;
    }

    if (currentX > width - margin) {
      currentX = margin;
      currentY = currentY + letterSize * 2;
    }
  }
  
  if (currentLine < lines.length - 1) {
    currentLine = currentLine + 1;
    if (currentX > margin) currentX = currentX + letterSize;
  }
  
  if (currentX > width - margin) {
    currentX = margin;
    currentY = currentY + letterSize * 2;
  }
}