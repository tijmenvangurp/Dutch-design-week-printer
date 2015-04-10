// Import Phidget Library
import com.phidgets.*;
import com.phidgets.event.*;

// Variables
PFont font;

int[] rfid_serial = new int[2];
RFIDPhidget rfid[] = new RFIDPhidget[rfid_serial.length]; // Array of #x RFID readers

void setup() {
  rfid_serial[0] = 34223; // RESET
  rfid_serial[1] = 151327; // PRINT
  
  size(100, 100);
 
  // SQL setup
 
  
  // Load RFID readers
  for(int i = 0; i < rfid_serial.length; i++) {
    try {
      rfid[i] = new RFIDPhidget();
      rfid[i].open(rfid_serial[i]); // open the x'th RFID reader with it's unique serial number
      // Attach an Add listener, so that we know when an Phidget is attached.
      rfid[i].addAttachListener(new AttachListener() {
          public void attached(AttachEvent ae)
          {
            try
            {
              ((RFIDPhidget)ae.getSource()).setLEDOn(false);
              ((RFIDPhidget)ae.getSource()).setAntennaOn(true);
            }
            catch (PhidgetException ex) {
            }
            println("attachment of " + ae);
          }
        }
      );
      // Attach an Detach listener, to catch an exception when an RFID reader is disconnected
      rfid[i].addDetachListener(new DetachListener()
        {
          public void detached(DetachEvent ae) {
            System.out.println("detachment of " + ae);
          }
        }
      );
      // Add an TAG listener, which inserts a new scan in the database and perhaps even a new user
      rfid[i].addTagGainListener(new TagGainListener()
        {
          public void tagGained(TagGainEvent oe)
          {
            System.out.println(oe);
            try {
              if(34223 == ((RFIDPhidget)oe.getSource()).getSerialNumber()) {
                //doClean(oe.getValue().toUpperCase());               
              } else {
                //doPrint(oe.getValue().toUpperCase());
              }
              ((RFIDPhidget)oe.getSource()).setLEDOn(true);
            } catch (PhidgetException ex) {
              println("uhm");
            }
          }
        }
      );
      // Add an TAG Lost listener, to do something when the TAG is lost.
      rfid[i].addTagLossListener(new TagLossListener()
        {
          public void tagLost(TagLossEvent oe)
          {
            System.out.println(oe);
            try {
              ((RFIDPhidget)oe.getSource()).setLEDOn(false);
            } catch (PhidgetException ex) {
              println("uhm");
            }
          }
        }
      );
    } catch (PhidgetException ex) {
      System.out.println(ex);
    }
  }
}

// Not much happening here yet, but needs to display the scan and the RFID readers that are attached in a nice way?
void draw() {
  
}



void doPrint(String tag) {
  
    tag = "xx" + tag.substring(2, 10);
         
    link("http://192.168.1.100/_Table/print/print.php?tag=" + tag);
    
   
   }
