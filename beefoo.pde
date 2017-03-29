String[] lines;
Table transcripts;
int letterSize = 1; // pixels
int imageSize = 10;
color[] palette = {
  #7fc97f,
  #cccccc,
  #fdc086,
  #ffff99,
  #386cb0
};

int currentNeighborhood = 0;
int currentTranscript = 0;
int currentLine = 1;
int columnWidth = 200;
int margin = 5;
int currentX = 0;
int currentY = 0;

int currentStatus;
int currentId = -1;
String currentText;

void setup() {
  size(792, 1224);
  background(255);
  noStroke();
  frameRate(120);

  println("loading");
  
  lines = loadStrings("lines.csv");
  
  println(lines.length + " total lines");
  
  transcripts = loadTable("transcripts.csv", "header");
  
  println(transcripts.getRowCount() + " total transcripts");

  currentX = margin;
  currentY = margin;
}

void draw() {
  getLineInfo();

  String words[] = currentText.split(" ");

  fill(palette[currentStatus]);

  //for (int j = 0; j < words.length; j++) {
    int count = words.length;//words[j].length();
    int w = count * letterSize;
    
    // check to make sure rect is in margin bounds
    if (currentX + w > width - margin) {
      currentX = margin;
      currentY = currentY + letterSize * 2;
    }

    rect(currentX, currentY, w, letterSize);
    
    currentX = currentX + w;
    
    //if (j+1 < words.length && currentX > margin) {
    //  currentX = currentX + letterSize;
    //}

    if (currentX > width - margin) {
      currentX = margin;
      currentY = currentY + letterSize * 2;
    }
  //}
  
  if (currentLine < lines.length - 1) {
    currentLine = currentLine + 1;
    //if (currentX > margin) currentX = currentX + letterSize;
  }
  
  if (currentX > width - margin) {
    currentX = margin;
    currentY = currentY + letterSize * 2;
  }
  
  //println(currentLine);
}

void startNeighborhood() {
  PImage img;
  img = loadImage("images/n" + currentNeighborhood + "m.jpg");
  currentX = margin;
  if (currentY > margin) currentY = currentY + letterSize;
  image(img, currentX, currentY);
  currentY = currentY + imageSize;
}

void startTranscript() {
  //currentX = margin;
  //if (currentY > margin) currentY = currentY + letterSize * 2;
  fill(0);
  rect(currentX, currentY, letterSize * 2, letterSize);
  currentX = currentX + letterSize * 2;
}

void getLineInfo() {
  String line = lines[currentLine];
  String row[] = line.split(",");
  int id = int(row[1]);
  int cid = int(row[0]);
  
  if (cid != currentNeighborhood) {
    currentNeighborhood = cid;
    //startNeighborhood();
  }
  
  if (id != currentId) {
    currentId = id;
    startTranscript();
  }
  currentStatus = int(row[5]);
  currentText = row[4].equals("\"\"") ? row[3] : row[4];
  currentText = currentText.replaceAll("\"", "");
}

void keyPressed() {
  if (key == 's') {
    saveFrame("output.png");
  }
}