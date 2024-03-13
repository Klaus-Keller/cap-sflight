# Demo flow

## Preparation

```
git clone -b sap-insider-start https://github.com/Klaus-Keller/cap-sflight.git
cd cap-sflight
npm i
code .
```

## Application Generation

- Command `Fiori: Open Application Generator`
- Create new List Report Page from local CAP project
- OData Service: `TravelService (Node.js)`
- Main entity: `Travel`
- Navigation entity: `None`

- Name: `travel`
- UI5 Version `1.120.9`
- Add deployment config: `No`

## Preview Application

- Preview Application on Application Info: `watch-travel`

## Add Filterfield

- Start Guided Development guide: `Add and edit filter fields`
- `app/travel/annotations.cds`
- `TravelService`
- `Travel`
- Property: `TravelStatus_code`
- Insert snippet

## Enable Flexible Column Layout

- Open Page Map
- Flexible Column Layout: `Flexible Column Layout`
- `Mid-Expanded`

## Add Custom Section and Table Macro

- Open page editor for TravelObjectPage
- Click `+` on sections and `Add Custom Section`
- Name `BookingsAndNotes`
- New Fragment Name: `BookingsAndNotesFragment`
- Anchor Section: `General Information (ID: Travel)`
- Placement: `After`
- Click `Add`
- Open Code and remove button

- Expand `BookingsAndNotesFragment` and click `+` att Building Block
- Add Table
- Click `Start Guide` and skip first step
- View or Fragment File: `webapp/ext/fragment/BookingsAndNotesFragment`
- Building Block ID: `Table`
- Binding Context Path: `Relative`
- Service: `TravelService`
- Entity: `Travel`
- Navigation Path: `to_Booking`
- Line Item Qualifier: `to_Booking/UI.LineItem`
- Aggregation Path: `/core:FragmentDefinition/VBox`
- Click `Insert Snippet`

## Add RichTextEdit

- in File `app/travel/webapp/ext/fragment/BookingsAndNotesFragment.fragment.xml` add RichTextEdit. The final content of the file:

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

- Start Page Map and click `+` on TravelObjectPage
- Select Page Type: `CustomPage`
- Navigation: `to_Booking (Booking)`
- View Name: `Custom`
- content:

```html
<html:iframe
  width="560"
  height="315"
  src="https://www.youtube.com/embed/FabiIE-IaSE?si=0jKSMd0fK6JUMoHQ"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
></html:iframe>
```
