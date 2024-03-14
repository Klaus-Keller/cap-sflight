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
- CDS File: `app/services.cds`
- Service: `TravelService`
- Entity: `Travel`
- Click `+ Add selection field`
- Property: `TravelStatus_code`
- Insert snippet

## Enable Flexible Column Layout

- Open Page Map
- Flexible Column Layout: `Flexible Column Layout`
- `Mid-Expanded`

## Add Custom Section

- Open page editor for TravelObjectPage
- Click `+` on sections and `Add Custom Section`
- Name `BookingsAndNotes`
- New Fragment Name: `BookingsAndNotesFragment`
- Anchor Section: `General Information (ID: Travel)`
- Placement: `After`
- Click `Add`
- Open Code and remove `<Button>..</Button>`

## Add Table Macro

- Expand `BookingsAndNotesFragment` and click `+` at Building Block
- Add Table
- Click `Start Guide` and skip to `2. Add table building block`
- View or Fragment File: `webapp/ext/fragment/BookingsAndNotesFragment`
- Building Block ID: `Table`
- Binding Context Path: `Relative`
- Service: `TravelService`
- Entity: `Travel`
- Navigation Path: `to_Booking`
- Line Item Qualifier: `to_Booking/UI.LineItem`
- Aggregation Path: `/core:FragmentDefinition/VBox`
- Associated Filter Bar ID: `FilterBar`
- Click `Insert Snippet`

## Add Filter Bar Macro

- Click `+` at Building Block again
- Click `Start Guide`
- CDS File: `app/services.cds`
- Service: `TravelService`
- Entity: `Booking`
- `+ Add Selection Field`
- Property: `BookingID`
- Click `Insert Snippet`
- Click `Next Step`
- View or Fragment File: `webapp/ext/fragment/BookingsAndNotesFragment`
- Building Block ID: `FilterBar`
- Service: `TravelService`
- Entity: `Booking`
- Selection Field Qualifier: `UI.SelectionFields` --> needs manually change to `to_Booking/@com.sap.vocabularies.UI.v1.SelectionFields`
- Aggregation Path: `/core:FragmentDefinition/VBox`
- Click `Insert Snippet`
- Move line `<macros:FilterBar ..` above `<macros:Table ..`

## Add RichTextEdit

- Open https://sapui5.hana.ondemand.com/test-resources/sap/fe/core/fpmExplorer/index.html#/buildingBlocks/rte/rteSection
- On the right, click on `More` -> `CustomSection.fragment.xml
- Click a row in list report
- The rich text edit is the last section `Custom Section`
- Switch to edit mode
- Add following additional button groups:
  ```xml
  <macros:buttonGroup name="font" visible="true" priority="10" customPriority="10" buttons="fontfamily,fontsize,forecolor,backcolor" />
   <macros:buttonGroup name="structure" visible="true" priority="10" customPriority="10" buttons="bullist, numlist, outdent, indent" />
   <macros:buttonGroup name="undo" visible="true" priority="10" customPriority="10" buttons="undo,redo" />
   <macros:buttonGroup name="link" visible="true" priority="10" customPriority="10" buttons="link, unlink" />
   <macros:buttonGroup name="text-align" visible="true" priority="10" customPriority="10" buttons="alignleft, aligncenter, alignright, alignjustify" />
  ```
- Copy the whole `<macros:RichTextEditorWithMetadata` and insert it into `app/travel/webapp/ext/fragment/BookingsAndNotesFragment.fragment.xml` below `<macros:Table ..`
- Change `metaPath="DescriptionProperty"` to `metaPath="AdditionalNotes"`
- The final content of the file `app/travel/webapp/ext/fragment/BookingsAndNotesFragment.fragment.xml`:
  ```xml
  <core:FragmentDefinition xmlns:core="sap.ui.core" xmlns="sap.m" xmlns:macros="sap.fe.macros">
      <VBox>
          <macros:FilterBar id="FilterBar" metaPath="to_Booking/@com.sap.vocabularies.UI.v1.SelectionFields"/>
          <macros:Table id="Table" metaPath="to_Booking/@com.sap.vocabularies.UI.v1.LineItem" filterBar="FilterBar" headerVisible="true" isSearchable="true" selectionMode="Single" type="ResponsiveTable" variantManagement="None"/>
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
      </VBox>
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
