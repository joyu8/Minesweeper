import de.bezier.guido.*;
import java.util.ArrayList;

public static final int  NUM_COLS = 20;
public static final int NUM_ROWS = 20;
public static final int NUM_MINES = 50;
private ArrayList<MSButton> mines = new ArrayList<MSButton>();
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS];

public void setup () {
    size(400, 400);
    textAlign(CENTER, CENTER);
   
    // make the manager
    Interactive.make( this );
  
    for (int n = 0; n < NUM_COLS; n++) {
        for (int i = 0; i < NUM_ROWS; i++) {
            buttons[n][i] = new MSButton(n, i);
        }
    }
  
    setMines();
}

public void setMines() {
    while (mines.size() < NUM_MINES) {
        int a = (int)(Math.random() * NUM_COLS);
        int b = (int)(Math.random() * NUM_ROWS);
        if (!mines.contains(buttons[a][b])) {
            mines.add(buttons[a][b]);
        }
    }
}

public void draw () {
    background(0);
    if (isWon()) {
        displayWinningMessage();
    frameRate(0);
    }
}

public boolean isWon() {
    int e = 0;
    int a = 0;
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!buttons[r][c].clicked && mines.contains(buttons[r][c])) {
                a++;
            }
            if (buttons[r][c].clicked && !mines.contains(buttons[r][c])) {
                e++;
            }
        }
    }
    return (e == (NUM_ROWS * NUM_COLS - NUM_MINES) && a == NUM_MINES);
}

public void displayWinningMessage() {
    fill(0, 255, 0);
    textAlign(CENTER, CENTER); 
    text("You lose", width / 2, height / 2); 

}

public void displayLosingMessage() { 
    fill(255, 0, 0); 
    textAlign(CENTER, CENTER); 
    text("You lose", width / 2, height / 2); 
    for (MSButton mine : mines) {
        mine.revealMine();
    }
}

public boolean isValid(int r, int c) {
    return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}

public int countMines(int row, int col) {
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && mines.contains(buttons[r][c])) {
                numMines++;
            }
        }
    }
    return numMines;
}

public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col ) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this); // register it with the manager
    }

   public void mousePressed() {
    if (clicked) {
        return;
    }
    
    clicked = true;
    if (mouseButton == RIGHT) {
        flagged = !flagged;
    } else if (mines.contains(this)) {
        displayLosingMessage();
        frameRate(0);
    } else if (countMines(myRow, myCol) > 0) {
        setLabel(countMines(myRow, myCol));
    } else { 
        for (int r = myRow - 1; r <= myRow + 1; r++) {
            for (int c = myCol - 1; c <= myCol + 1; c++) {
                if (isValid(r, c) && !buttons[r][c].clicked && !mines.contains(buttons[r][c])) {
                    buttons[r][c].mousePressed();
                }
            }
        }
    }
}

   
    public void draw() {    
        if (flagged) {
            fill(0);
            rect(x, y, width, height);
        } else if (clicked && mines.contains(this)) {
            fill(255, 0, 0);
            rect(x, y, width, height);
        } else if (clicked) {
            fill(#76767a);
            rect(x, y, width, height);
            fill(0);
            text(myLabel, x + width / 2, y + height / 2);
        } else {
            fill(#bdbdbd);
            rect(x, y, width, height);
        }
    }
   
    public void setLabel(String newLabel) {
        myLabel = newLabel;
    }

    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }

    public void revealMine() {
        clicked = true;
    }
}
