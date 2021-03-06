String[] lines;
Table collections;
Table transcripts;
Table transcriptLengths;
int letterSize = 1; // pixels
int imageSize = 10;
color[] palette = {
  #7fc97f,
  #beaed4,
  #7fc97f,
  //#fdc086,
  #ffff99,
  #386cb0
};

color[] collectionPalette = {
  #66c2a5,
  #fc8d62,
  #8da0cb,
  #e78ac3,
  #a6d854
};

color[] transcriptPalette = {
  #c0c0c0,
  #c0c0c0
};

int[] selected = {89, 97, 447, 478, 143, 150, 536, 358};

int collectionWidth = 50;
int transcriptWidth = 50;

int currentNeighborhood = 0;
int currentLine = 1;
int columnWidth = 200;
int margin = 50;
int currentX = 0;
int currentY = 0;

int currentStatus;
int currentId = -1;
String currentText;

boolean drewNeighborhoods = false;
boolean drewTranscripts = false;
boolean drewLines = false;

void setup() {
  size(792, 1224);
  noSmooth();
  background(255);
  noStroke();
  frameRate(120);

  println("loading");
  
  lines = loadStrings("lines_poster.csv");
  println(lines.length + " total lines");
  
  collections = loadTable("collections.csv", "header");
  println(collections.getRowCount() + " total collections");

  transcriptLengths = loadTable("transcript_lengths.csv", "header");

  transcripts = loadTable("transcripts.csv", "header");
  transcripts.addColumn("x");
  transcripts.addColumn("y");

  currentX = margin;
  currentY = margin;
}

void draw() {
  if (!drewNeighborhoods) drawNeighborhoods();
  if (!drewTranscripts) drawTranscripts();
  if (!drewLines) drawLines();
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
      currentX = margin + collectionWidth + transcriptWidth + letterSize;
      currentY = currentY + letterSize * 2;
    }

    rect(currentX, currentY, w, letterSize);
    
    currentX = currentX + w + letterSize;
    
    //if (j+1 < words.length && currentX > margin) {
    //  currentX = currentX + letterSize;
    //}

    if (currentX > width - margin) {
      currentX = margin + collectionWidth + transcriptWidth + letterSize;
      currentY = currentY + letterSize * 2;
    }
  }
  
  if (currentLine < lines.length - 1) {
    currentLine = currentLine + 1;
    //if (currentX > margin) currentX = currentX + letterSize;
  } else {
    drewLines = true;
  }
  
  if (currentX > width - margin) {
    currentX = margin + collectionWidth + transcriptWidth + letterSize;
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

boolean findId(int id) {
  for (int i = 0; i < selected.length; i++) {
    if (selected[i] == id) return true;
  }
  return false;
}

void drawTranscripts() {
  int i = 0;
  
  currentX = margin + collectionWidth;
  currentY = margin;
  
  for (TableRow row : transcripts.rows()) {
    
    String id = row.getString("id");
    int collection_id = row.getInt("collection_id");
    
    i++;
    
    if (!findId(int(id))) {
      fill(transcriptPalette[i%transcriptPalette.length]);
    } else {
      fill(0);
    }
    
    TableRow result = transcriptLengths.findRow(id, "transcript_id");

    int count;
    if (result != null) {
      count = result.getInt("sum");
    } else {
      count = 0;
    }
    
    //println(count, log10(count));
    
    float w = 0;
    if (count > 0) w = transcriptWidth * scaleLength(count);
    rect(currentX, currentY, ceil(w), letterSize);
    row.setInt("x", currentX + ceil(w));
    row.setInt("y", currentY);
    currentY += letterSize;
  }
  
  currentX = margin + collectionWidth + transcriptWidth + letterSize;
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
  //TableRow result = transcripts.findRow(str(currentId), "id");
  //stroke(#d0d0d0);
  //strokeWeight(1);
  //line(currentX, currentY, result.getInt("x"), result.getInt("y"));
  //noStroke();
  currentX = currentX + letterSize * 3;
  println("interview:", currentId);
}

void getLineInfo() {
  //boolean found = false;
  //while (!found) {
    String line = lines[currentLine];
    String row[] = line.split(",");
    int id = int(row[0]);
    //int cid = int(row[0]);
    int status = int(row[3]);
    
    //if (status != 1) {
      //found = true;
    
      //if (cid != currentNeighborhood) {
      //  currentNeighborhood = cid;
      //  //startNeighborhood();
      //}
      
      if (id != currentId) {
        currentId = id;
        startTranscript();
      }
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