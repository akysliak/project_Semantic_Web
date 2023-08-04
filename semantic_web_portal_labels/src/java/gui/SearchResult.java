package gui;

import java.util.HashMap;
import java.util.LinkedList;

/**
 *
 * @author Anastasiia Kysliak
 */
public class SearchResult {
    private final HashMap<String, LinkedList<String>> searchResult;
    private boolean show = false;
    public SearchResult(HashMap<String, LinkedList<String>> res) {
        searchResult = res;
    }

    public HashMap<String, LinkedList<String>> getSearchResult(){
        return searchResult;
    }

    public void setShow(boolean show){
        this.show = show;
    }

    public boolean getShow() {
        return show;
    }
}
