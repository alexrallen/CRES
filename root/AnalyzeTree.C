#include "TFile.h"
#include "TTree.h"

void AnalyzeTree()
{
   // Variables used to store the data
   // Int_t     totalSize = 0;        // Sum of data size (in bytes) of all events

   // open the file
   TFile *f = TFile::Open("./output/ConstantBField.root");
   if (f == 0) {
      // if we cannot open the file, print an error message and return immediatly
      printf("Error: cannot open http://root.cern/files/introtutorials/eventdata.root!\n");
      return;
   }

   new TTreeViewer("component_track_world_DATA");

   // Create a plot of kinetic energy over time
   //TTree* tree = (TTree*)f->Get("component_step_world_DATA");
   //tree->Draw("kinetic_energy:step_id","continuous_time>-1");

   /*
   // Create tyhe tree reader and its data containers
   TTreeReader myReader("component_step_world_DATA", f);

   TTreeReaderValue<Int_t> eventSize(myReader, "fEventSize");

   // Loop over all entries of the TTree or TChain.
   while (myReader.Next()) {
      // Get the data from the current TTree entry by getting
      // the value from the connected reader (eventSize):
      totalSize += *eventSize;
   }


   Int_t sizeInMB = totalSize/1024/1024;
   printf("Total size of all events: %d MB\n", sizeInMB);
   */


}


