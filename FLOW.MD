# Demo flow

TODO: Clean up existing apps?

## Application Generation

- Create new Fiori app LROP from local CAP project
- `Travel Service (node.js)`
- Main entity: `Travel`
- Navigation entity: `None`

- Name: `travel`
- UI5 Version `1.120.9`
- Add deployment config: `No`

## Preview Application

- Preview Application on Application Info: `watch-travel`

## Add Filterfield

- Start Guided Development
- `app/travel/annotations.cds`
- `TravelService`
- `Travel`
- Add selection field
- Property: `TravelStatus_code`
- Insert snippet

## Enable Flexible Column Layout

- Open Page Map
- Flexible Column Layout: `Flexible Column Layout`
- `Mid-Expanded`

## Add Custom Section and Table Macro

- add custom section
- remove button from code

- add table macro
- skip first step
- View or Fragment File: `webapp/ext/fragment/CustomFragment`
- Building Block ID: `Table`
- Service: `TravelService`
- Entity: `Travel`
- Navigation Path: `to_Booking`
- Aggregation Path: `/core:FragmentDefinition/VBox`

## Add RichTextEdit

Insert in `app/travel/webapp/ext/fragment/CustomFragment.fragment.xml`

```xml
<core:FragmentDefinition xmlns:layout="sap.ui.layout" xmlns:core="sap.ui.core" xmlns="sap.m" xmlns:macros="sap.fe.macros">
    <layout:ResponsiveSplitter>
        <layout:PaneContainer >
            <layout:SplitPane >
                    <macros:Table id="Table" metaPath="to_Booking/@com.sap.vocabularies.UI.v1.LineItem" headerVisible="true" isSearchable="true" selectionMode="Single" type="ResponsiveTable" variantManagement="None"/>
            </layout:SplitPane>
            <layout:SplitPane>
                <macros:RichTextEditorWithMetadata metaPath="AdditionalNotes" id="myRichTextEditor">
                        <macros:buttonGroups>
                            <macros:buttonGroup name="font-style" visible="true" priority="10" customPriority="10" buttons="bold,italic,underline" />
                            <macros:buttonGroup name="font" visible="true" priority="10" customPriority="10" buttons="fontfamily,fontsize,forecolor,backcolor" />
                            <macros:buttonGroup name="structure" visible="true" priority="10" customPriority="10" buttons="bullist, numlist, outdent, indent" />
                            <macros:buttonGroup name="undo" visible="true" priority="10" customPriority="10" buttons="undo,redo" />
                            <macros:buttonGroup name="link" visible="true" priority="10" customPriority="10" buttons="link, unlink" />
                            <macros:buttonGroup name="text-align" visible="true" priority="10" customPriority="10" buttons="alignleft, aligncenter, alignright, alignjustify" />
                        </macros:buttonGroups>
                    </macros:RichTextEditorWithMetadata>
            </layout:SplitPane>
        </layout:PaneContainer>
    </layout:ResponsiveSplitter>
</core:FragmentDefinition>
```

## Add Custom Page

(app modeler)

- content?
