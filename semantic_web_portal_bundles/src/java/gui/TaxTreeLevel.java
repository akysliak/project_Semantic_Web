package gui;

import java.util.LinkedList;

/**
 *
 * @author Anastasiia Kysliak
 */
public class TaxTreeLevel {
    private LinkedList<String> elementList;
    private final TaxTreeLevelsNames thisLevelName;
    private final String nameAsSring;
    private String selectedElement = "";

    public TaxTreeLevel(TaxTreeLevelsNames levelName, LinkedList<String> elList) {
        elementList = elList;
        thisLevelName = levelName;
        nameAsSring = thisLevelName.toString().toLowerCase();
    }
    public void setElementList(LinkedList<String> newList) {
        elementList = newList;
    }

    public void setSelectedElement(String selElement) {
        selectedElement = selElement;
    }

    public LinkedList<String> getElementList() {
        return elementList;
    }

    public TaxTreeLevelsNames getThisLevelName() {
        return thisLevelName;
    }

    public String getNameAsString() {
        return nameAsSring;
    }

    public boolean hasSelectedElement() {
        return !selectedElement.isEmpty();
    }
    public String getSelectedElement() {
        return selectedElement;
    }
}
