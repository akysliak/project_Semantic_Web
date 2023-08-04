package gui;

import java.util.HashMap;
import java.util.LinkedList;
import mswQuery.MSWQuery;

/**
 *
 * @author Anastasiia Kysliak
 */
public class DetailedResultsList {
   private HashMap<String, SearchResult> detailedResultsList = new HashMap<String, SearchResult>();
   public DetailedResultsList() {

   }
   public void addResult(String key, HashMap<String, LinkedList<String>> searchResult) {
       detailedResultsList.put(key, new SearchResult(searchResult));
   }

   public boolean informationAvailable(String key) {
       return detailedResultsList.containsKey(key);
   }

   public SearchResult getResult(String key) {
       SearchResult sr = detailedResultsList.get(key);
       if (sr == null) {
           sr = new SearchResult(MSWQuery.searchByScientificName(key, Properties.getProperties()));
           detailedResultsList.put(key, sr);
       }
       return sr;
   }
}
