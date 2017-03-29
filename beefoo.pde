String[] lines;
Table collections;
Table transcripts;
Table transcriptLengths;
int letterSize = 1; // pixels
int imageSize = 10;
color[] palette = {
  #7fc97f,
  #cccccc,
  #7fc97f,
  #fdc086,
  #ffff99,
  #386cb0
};

color[] collectionPalette = {
  #ffff00,
  #00ffff,
  #00ff00,
  #cc99ff,
  #ff0000,
  #3366ff
};

color[] transcriptPalette = {
  #c0c0c0,
  #c0c0c0
};

int collectionWidth = 50;
int transcriptWidth = 50;

int currentNeighborhood = 0;
int currentLine = 1;
int columnWidth = 200;
int margin = 5;
int currentX = 0;
int currentY = 0;

int currentStatus;
int currentId = -1;
String currentText;

boolean drewNeighborhoods = false;
boolean drewTranscripts = false;

void setup() {
  size(1836, 1188);
  background(255);
  noStroke();
  frameRate(120);

  println("loading");
  
  lines = loadStrings("lines_senior.csv");
  println(lines.length + " total lines");
  
  collections = loadTable("collections.csv", "header");
  println(collections.getRowCount() + " total collections");

  transcriptLengths = loadTable("transcript_lengths.csv", "header");

  transcripts = loadTable("transcripts.csv", "header");

  currentX = margin;
  currentY = margin;
}

void draw() {
  if (!drewNeighborhoods) drawNeighborhoods();
  if (!drewTranscripts) drawTranscripts();
  drawLines();
}

void drawLines() {
  getLineInfo();

  String words[] = currentText.split(" ");

  fill(palette[currentStatus]);

  for (int j = 0; j < words.length; j++) {
    int count = words[j].length();
    int w = count * letterSize;
    
    // check to make sure rect is in margin bounds
    if (currentX + w > width - margin) {
      currentX = margin + collectionWidth + transcriptWidth;
      currentY = currentY + letterSize * 2;
    }

    rect(currentX, currentY, w, letterSize);
    
    currentX = currentX + w + letterSize;
    
    //if (j+1 < words.length && currentX > margin) {
    //  currentX = currentX + letterSize;
    //}

    if (currentX > width - margin) {
      currentX = margin + collectionWidth + transcriptWidth;
      currentY = currentY + letterSize * 2;
    }
  }
  
  if (currentLine < lines.length - 1) {
    currentLine = currentLine + 1;
    if (currentX > margin) currentX = currentX + letterSize;
  }
  
  if (currentX > width - margin) {
    currentX = margin + collectionWidth + transcriptWidth;
    currentY = currentY + letterSize * 2;
  }
  
  //println(currentLine);
}

void drawNeighborhoods() {
  int i = 0;

  for (TableRow row : collections.rows()) {
    
    int id = row.getInt("collection_id");
    int count = row.getInt("count");
    
    i++;
    
    fill(collectionPalette[i%collectionPalette.length]);
    
    int h = letterSize * count;
    rect(currentX, currentY, collectionWidth, h);
    currentY += h;
  }
  
  drewNeighborhoods = true;
}

float log10 (int x) {
  return (log(x) / log(10));
}

float scaleLength(int count) {
  float max = 178666;
  float c = float(count);
  if (c<=0) return 0.0;
  return c/max;
}

void drawTranscripts() {
  int i = 0;
  
  currentX = margin + collectionWidth;
  currentY = margin;
  
  for (TableRow row : transcripts.rows()) {
    
    String id = row.getString("id");
    int collection_id = row.getInt("collection_id");
    
    i++;
    
    fill(transcriptPalette[i%transcriptPalette.length]);
    
    TableRow result = transcriptLengths.findRow(id, "transcript_id");

    int count;
    if (result != null) {
      count = result.getInt("sum");
    } else {
      count = 0;
    }
    
    println(count, log10(count));
    
    float w = 0;
    if (count > 0) w = transcriptWidth * scaleLength(count);
    rect(currentX, currentY, ceil(w), letterSize);
    currentY += letterSize;
  }
  
  currentX = margin + collectionWidth + transcriptWidth;
  currentY = margin;
  drewTranscripts = true;
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
  println("interview:", currentId);
}

void getLineInfo() {
  //boolean found = false;
  //while (!found) {
    String line = lines[currentLine];
    String row[] = line.split(",");
    int id = int(row[1]);
    //int cid = int(row[0]);
    int status = int(row[3]);
    
    //if (status != 1) {
      //found = true;
    
      //if (cid != currentNeighborhood) {
      //  currentNeighborhood = cid;
      //  //startNeighborhood();
      //}
      
      //if (id != currentId) {
      //  currentId = id;
      //  startTranscript();
      //}
      currentStatus = status;
      currentText = row[2].equals("\"\"") ? row[1] : row[2];
      currentText = currentText.replaceAll("\"", "");
    //} else {
    //  currentLine = currentLine + 1;
    //}
  //}
}

void keyPressed() {
  if (key == 's') {
    saveFrame("output.png");
  }
}