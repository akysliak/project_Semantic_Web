package gui;

import mswQuery.MSWQuery;
import java.util.Arrays;
import java.util.LinkedList;

/**
 *
 * @author Anastasiia Kysliak
 */

public class TaxonomicTree {

   private final TaxTreeLevelsNames[] levelsNames  = TaxTreeLevelsNames.values();
   private final String[] levelsNamesAsString = new String[levelsNames.length];
   private TaxTreeLevel[] levels = new TaxTreeLevel[levelsNames.length];
   private String smallestSelectedElement = null;

   private String selected_level = "none_1";

   public TaxonomicTree() {
       setAll();
   }
   private void setAll() {
      for (int i = 0; i < levels.length; i++) {
          String levelName = levelsNames[i].name().toLowerCase();
          levels[i] = new TaxTreeLevel(levelsNames[i], MSWQuery.getTaxTreeLevelList(levelName));
          levelsNamesAsString[i] = levelName;
      }
   }

   public void reset() {
       setAll();
   }

   public String[] getLevelsNamesAsString() {
       return levelsNamesAsString;
   }
   public TaxTreeLevel[] getLevels() {
       return levels;
   }

   public void setSelectedLevel(String level_name) {
       this.selected_level = level_name;
   }
   public String getSelectedLevel() {
       return this.selected_level;
   }
   public void setSelectedElement(TaxTreeLevelsNames selectedLevelName, String element) {
        if(element.isEmpty()) {
            return;
        }
       for (TaxTreeLevel level : levels) {
           TaxTreeLevelsNames curLevelName = level.getThisLevelName();
           if(curLevelName.compareTo(selectedLevelName) > 0) {
               LinkedList<String> elementList = MSWQuery.getTaxTreeLevelList(curLevelName.toString(), element);
               level.setElementList(elementList);
               level.setSelectedElement("");
           }
           else if(curLevelName.compareTo(selectedLevelName) < 0) {
                LinkedList<String> searchedLevel = MSWQuery.getTaxTreeLevelForAncestor(curLevelName.toString(), element);
                if(!searchedLevel.isEmpty()) {
                    level.setSelectedElement(searchedLevel.getFirst());
                }
           }
           else {
               level.setSelectedElement(element);
           }
       }
   }
    public void unselectElement(int ind) {
        levels[ind].setSelectedElement("");
    }
   public TaxTreeLevel getSmallestSelectedElement() {
       TaxTreeLevel res = null;
       for (int i = 0; i < levels.length; i++) {
           if(levels[i].hasSelectedElement()) {
               res = levels[i];
           }
       }
       return res;
   }
}
