import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  bombs = new ArrayList<MSButton>(); 

  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      buttons[r][c] = new MSButton(r, c );
    }
  }

  //declare and initialize buttons
  setBombs();
}
public void setBombs()
{
  int numBombs = 20;
  for (int i = 0; i < numBombs; i++)
  {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (! bombs.contains(buttons[row][col]))
    {
      bombs.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  int markBombs= 0;
  for (int i=0; i<bombs.size (); i++)
  {
    if (bombs.get(i).isMarked()==true)
    {
      markBombs++;
    }
  }
  if (markBombs==bombs.size())
  {
    return true;
  }
  for (int i=0; i<bombs.size (); i++)
  {
    if (bombs.get(i).isClicked()==true)
    {
      displayLosingMessage();
    }
  }
  return false;
}
public void displayLosingMessage()
{
  for (int i=0; i<bombs.size (); i++)
  {
    bombs.get(i).isClicked();
  }
  buttons[6][6].setLabel("Y");
  buttons[6][7].setLabel("O");
  buttons[6][8].setLabel("U");
  buttons[6][9].setLabel(" ");
  buttons[6][10].setLabel("L");
  buttons[6][11].setLabel("O");
  buttons[6][12].setLabel("S");
  buttons[6][13].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[6][6].setLabel("Y");
  buttons[6][7].setLabel("O");
  buttons[6][8].setLabel("U");
  buttons[6][9].setLabel(" ");
  buttons[6][10].setLabel("W");
  buttons[6][11].setLabel("I");
  buttons[6][12].setLabel("N");
  buttons[6][13].setLabel("!");
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager
  public void mousePressed () 
  {
    if (mouseButton == LEFT)
      clicked = true;
    if (mouseButton == RIGHT)
      marked = !marked;
    else if (bombs.contains(this))
    {
      displayLosingMessage();
    } else if (countBombs(r, c)>0)
    {
      label = label + countBombs(r, c);
      println("label");
    } else
    {
      for (int i=-1; i<2; i++)
      {
        for (int j=-1; j<2; j++)
        {
          if (isValid(r+i, c+j)==true)
          {
            if (buttons[r+i][c+j].isClicked()==false)
            {
              buttons[r+i][c+j].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    return (r>=0 && r<NUM_ROWS) && (c>=0 && c<NUM_COLS);
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for ( int i = -1; i<2; i++)
      for (int j = -1; j<2; j++)
        if (isValid(row + i, col + j))
          if (bombs.contains(buttons[row+i][col+j]))
            numBombs++;

    return numBombs;
  }
}
