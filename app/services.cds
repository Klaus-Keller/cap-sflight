using {Currency} from '../db/common';
using TravelService from '../srv/travel-service';
using from './travel_processor/capabilities';
using from './travel_processor/field-control';
using from './travel_analytics/annotations';


annotate TravelService.Travel with @UI: {SelectionFields: [
    to_Agency_AgencyID,
    to_Customer_CustomerID,
    TravelStatus_code,
]};

// Workarounds for overly strict OData libs and clients
annotate cds.UUID with  @Core.Computed  @odata.Type: 'Edm.String';
annotate Currency with @Common.UnitSpecificScale: 'Decimals';


annotate TravelService.Travel with @UI: {

    Identification        : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.acceptTravel',
            Label : '{i18n>AcceptTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : '{i18n>RejectTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.deductDiscount',
            Label : '{i18n>DeductDiscount}'
        }
    ],
    HeaderInfo            : {
        TypeName      : '{i18n>Travel}',
        TypeNamePlural: '{i18n>Travels}',
        Title         : {
            $Type: 'UI.DataField',
            Value: Description
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: TravelID
        }
    },
    PresentationVariant   : {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : TravelID,
            Descending: true
        }]
    },
    LineItem              : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.acceptTravel',
            Label : '{i18n>AcceptTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : '{i18n>RejectTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.deductDiscount',
            Label : '{i18n>DeductDiscount}'
        },
        {
            Value         : TravelID,
            @UI.Importance: #High
        },
        {
            Value             : to_Agency_AgencyID,
            @HTML5.CssDefaults: {width: '16em'}
        },
        {
            Value             : to_Customer_CustomerID,
            @UI.Importance    : #High,
            @HTML5.CssDefaults: {width: '14em'}
        },
        {
            Value             : BeginDate,
            @HTML5.CssDefaults: {width: '9em'}
        },
        {
            Value             : EndDate,
            @HTML5.CssDefaults: {width: '9em'}
        },
        {
            Value             : BookingFee,
            @HTML5.CssDefaults: {width: '10em'}
        },
        {
            Value             : TotalPrice,
            @HTML5.CssDefaults: {width: '12em'}
        },
        {
            Value             : TravelStatus_code,
            Criticality       : {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'TravelStatus_code'},
                    'O'
                ]},
                2,
                {$If: [
                    {$Eq: [
                        {$Path: 'TravelStatus_code'},
                        'A'
                    ]},
                    3,
                    0
                ]}
            ]}},
            @UI.Importance    : #High,
            @HTML5.CssDefaults: {width: '10em'}
        }
    ],
    Facets                : [{
        $Type : 'UI.CollectionFacet',
        Label : '{i18n>GeneralInformation}',
        ID    : 'Travel',
        Facets: [
            { // travel details
                $Type : 'UI.ReferenceFacet',
                ID    : 'TravelData',
                Target: '@UI.FieldGroup#TravelData',
                Label : '{i18n>GeneralInformation}'
            },
            { // price information
                $Type : 'UI.ReferenceFacet',
                ID    : 'PriceData',
                Target: '@UI.FieldGroup#PriceData',
                Label : '{i18n>Prices}'
            },
            { // date information
                $Type : 'UI.ReferenceFacet',
                ID    : 'DateData',
                Target: '@UI.FieldGroup#DateData',
                Label : '{i18n>Dates}'
            }
        ]
    }],
    FieldGroup #TravelData: {Data: [
        {Value: TravelID},
        {Value: to_Agency_AgencyID},
        {Value: to_Customer_CustomerID},
        {Value: Description},
        {
            $Type      : 'UI.DataField',
            Value      : TravelStatus_code,
            Criticality: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'TravelStatus_code'},
                    'O'
                ]},
                2,
                {$If: [
                    {$Eq: [
                        {$Path: 'TravelStatus_code'},
                        'A'
                    ]},
                    3,
                    0
                ]}
            ]}},
            Label      : '{i18n>Status}' // label only necessary if differs from title of element
        }
    ]},
    FieldGroup #DateData  : {Data: [
        {
            $Type: 'UI.DataField',
            Value: BeginDate
        },
        {
            $Type: 'UI.DataField',
            Value: EndDate
        }
    ]},
    FieldGroup #PriceData : {Data: [
        {
            $Type: 'UI.DataField',
            Value: BookingFee
        },
        {
            $Type: 'UI.DataField',
            Value: TotalPrice
        },
        {
            $Type: 'UI.DataField',
            Value: CurrencyCode_code
        }
    ]}
};

annotate TravelService.Booking with @UI: {
    Identification                : [{Value: BookingID}, ],
    HeaderInfo                    : {
        TypeName      : '{i18n>Bookings}',
        TypeNamePlural: '{i18n>Bookings}',
        Title         : {Value: to_Customer.LastName},
        Description   : {Value: BookingID}
    },
    PresentationVariant           : {
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingID,
            Descending: false
        }]
    },
    SelectionFields               : [],
    LineItem                      : [
        {
            Value: to_Carrier.AirlinePicURL,
            Label: '  '
        },
        {Value: BookingID},
        {Value: BookingDate},
        {Value: to_Customer_CustomerID},
        {Value: to_Carrier_AirlineID},
        {
            Value: ConnectionID,
            Label: '{i18n>FlightNumber}'
        },
        {Value: FlightDate},
        {Value: FlightPrice},
        {
            Value      : BookingStatus_code,
            Criticality: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'BookingStatus_code'},
                    'N'
                ]},
                2,
                {$If: [
                    {$Eq: [
                        {$Path: 'BookingStatus_code'},
                        'B'
                    ]},
                    3,
                    0
                ]}
            ]}}
        }
    ],
    Facets                        : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>GeneralInformation}',
            ID    : 'Booking',
            Facets: [
                { // booking details
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'BookingData',
                    Target: '@UI.FieldGroup#GeneralInformation',
                    Label : '{i18n>Booking}'
                },
                { // flight details
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'FlightData',
                    Target: '@UI.FieldGroup#Flight',
                    Label : '{i18n>Flight}'
                }
            ]
        },
        { // supplements list
            $Type : 'UI.ReferenceFacet',
            ID    : 'SupplementsList',
            Target: 'to_BookSupplement/@UI.PresentationVariant',
            Label : '{i18n>BookingSupplements}'
        }
    ],
    FieldGroup #GeneralInformation: {Data: [
        {Value: BookingID},
        {Value: BookingDate, },
        {Value: to_Customer_CustomerID},
        {Value: BookingDate, },
        {
            Value      : BookingStatus_code,
            Criticality: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'BookingStatus_code'},
                    'N'
                ]},
                2,
                {$If: [
                    {$Eq: [
                        {$Path: 'BookingStatus_code'},
                        'B'
                    ]},
                    3,
                    0
                ]}
            ]}}
        }
    ]},
    FieldGroup #Flight            : {Data: [
        {Value: to_Carrier_AirlineID},
        {Value: ConnectionID},
        {Value: FlightDate},
        {Value: FlightPrice}
    ]},
};

annotate TravelService.BookingSupplement with @UI: {
    Identification     : [{Value: BookingSupplementID}],
    HeaderInfo         : {
        TypeName      : '{i18n>BookingSupplement}',
        TypeNamePlural: '{i18n>BookingSupplements}',
        Title         : {Value: BookingSupplementID},
        Description   : {Value: BookingSupplementID}
    },
    PresentationVariant: {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingSupplementID,
            Descending: false
        }]
    },
    LineItem           : [
        {Value: BookingSupplementID},
        {
            Value: to_Supplement_SupplementID,
            Label: '{i18n>ProductID}'
        },
        {
            Value: Price,
            Label: '{i18n>ProductPrice}'
        }
    ],
};

//
// annotations that control rendering of fields and labels
//

annotate schema.Travel with @title: '{i18n>Travel}' {
    TravelUUID      @UI.Hidden;
    TravelID        @title        : '{i18n>TravelID}'      @Common.Text         : Description;
    BeginDate       @title        : '{i18n>BeginDate}';
    EndDate         @title        : '{i18n>EndDate}';
    Description     @title        : '{i18n>Description}';
    AdditionalNotes @title        : '{i18n>AdditionalNotes}';
    BookingFee      @title        : '{i18n>BookingFee}'    @Measures.ISOCurrency: CurrencyCode_code;
    TotalPrice      @title        : '{i18n>TotalPrice}'    @Measures.ISOCurrency: CurrencyCode_code;
    TravelStatus    @title        : '{i18n>TravelStatus}'  @Common.Text         : TravelStatus.name  @Common.TextArrangement: #TextOnly;
    to_Customer     @title        : '{i18n>CustomerID}'    @Common.Text         : to_Customer.LastName;
    to_Agency       @title        : '{i18n>AgencyID}'      @Common.Text         : to_Agency.Name;
}

annotate schema.TravelStatus with {
    code  @Common.Text: name  @Common.TextArrangement: #TextOnly
}

annotate schema.Booking with @title: '{i18n>Booking}' {
    BookingUUID    @UI.Hidden;
    to_Travel      @UI.Hidden;
    BookingID      @title          : '{i18n>BookingID}';
    BookingDate    @title          : '{i18n>BookingDate}';
    ConnectionID   @title          : '{i18n>ConnectionID}';
    CurrencyCode   @title          : '{i18n>CurrencyCode}';
    FlightDate     @title          : '{i18n>FlightDate}';
    FlightPrice    @title          : '{i18n>FlightPrice}'    @Measures.ISOCurrency: CurrencyCode_code;
    BookingStatus  @title          : '{i18n>BookingStatus}'  @Common.Text         : BookingStatus.name  @Common.TextArrangement: #TextOnly;
    to_Carrier     @title          : '{i18n>AirlineID}'      @Common.Text         : to_Carrier.Name;
    to_Customer    @title          : '{i18n>CustomerID}'     @Common.Text         : to_Customer.LastName;
}

annotate schema.BookingStatus with {
    code  @Common.Text: name  @Common.TextArrangement: #TextOnly
}

annotate schema.BookingSupplement with @title: '{i18n>BookingSupplement}' {
    BookSupplUUID       @UI.Hidden;
    to_Booking          @UI.Hidden;
    to_Travel           @UI.Hidden;
    to_Supplement       @title               : '{i18n>SupplementID}'  @Common.Text         : to_Supplement.Description;
    Price               @title               : '{i18n>Price}'         @Measures.ISOCurrency: CurrencyCode_code;
    BookingSupplementID @title               : '{i18n>BookingSupplementID}';
    CurrencyCode        @title               : '{i18n>CurrencyCode}';
}

annotate schema.TravelAgency with @title: '{i18n>TravelAgency}' {
    AgencyID     @title                 : '{i18n>AgencyID}'  @Common.Text: Name;
    Name         @title                 : '{i18n>AgencyName}';
    Street       @title                 : '{i18n>Street}';
    PostalCode   @title                 : '{i18n>PostalCode}';
    City         @title                 : '{i18n>City}';
    CountryCode  @title                 : '{i18n>CountryCode}';
    PhoneNumber  @title                 : '{i18n>PhoneNumber}';
    EMailAddress @title                 : '{i18n>EMailAddress}';
    WebAddress   @title                 : '{i18n>WebAddress}';
}

annotate schema.Passenger with @title: '{i18n>Passenger}' {
    CustomerID   @title              : '{i18n>CustomerID}'  @Common.Text: LastName;
    FirstName    @title              : '{i18n>FirstName}';
    LastName     @title              : '{i18n>LastName}';
    Title        @title              : '{i18n>Title}';
    Street       @title              : '{i18n>Street}';
    PostalCode   @title              : '{i18n>PostalCode}';
    City         @title              : '{i18n>City}';
    CountryCode  @title              : '{i18n>CountryCode}';
    PhoneNumber  @title              : '{i18n>PhoneNumber}';
    EMailAddress @title              : '{i18n>EMailAddress}';
}

annotate schema.Airline with @title: '{i18n>Airline}' {
    AirlineID    @title            : '{i18n>AirlineID}'  @Common.Text: Name;
    Name         @title            : '{i18n>Name}';
    CurrencyCode @title            : '{i18n>CurrencyCode}';
}

annotate schema.Flight with @title: '{i18n>Flight}' {
    AirlineID     @title          : '{i18n>AirlineID}';
    FlightDate    @title          : '{i18n>FlightDate}';
    ConnectionID  @title          : '{i18n>ConnectionID}';
    CurrencyCode  @title          : '{i18n>CurrencyCode}';
    Price         @title          : '{i18n>Price}'  @Measures.ISOCurrency: CurrencyCode_code;
    PlaneType     @title          : '{i18n>PlaneType}';
    MaximumSeats  @title          : '{i18n>MaximumSeats}';
    OccupiedSeats @title          : '{i18n>OccupiedSeats}';
}

annotate schema.Supplement with @title: '{i18n>Supplement}' {
    SupplementID  @title              : '{i18n>SupplementID}'  @Common.Text         : Description;
    Price         @title              : '{i18n>Price}'         @Measures.ISOCurrency: CurrencyCode_code;
    CurrencyCode  @title              : '{i18n>CurrencyCode}';
    Description   @title              : '{i18n>Description}';
}


using {sap.fe.cap.travel as schema} from '../db/schema';

//
// annotations for value helps
//

annotate schema.Travel {

    TravelStatus @Common.ValueListWithFixedValues;

    to_Agency    @Common.ValueList: {
        CollectionPath: 'TravelAgency',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Agency_AgencyID,
                ValueListProperty: 'AgencyID'
            }, // local data property is the foreign key
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Street'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PostalCode'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'City'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CountryCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PhoneNumber'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'EMailAddress'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'WebAddress'
            }
        ]
    };

    to_Customer  @Common.ValueList: {
        CollectionPath: 'Passenger',
        Label         : 'Customer ID',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Customer_CustomerID,
                ValueListProperty: 'CustomerID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'FirstName'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'LastName'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Title'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Street'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PostalCode'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'City'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CountryCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PhoneNumber'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'EMailAddress'
            }
        ]
    };

    CurrencyCode @Common.ValueList: {
        CollectionPath: 'Currencies',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'descr'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'symbol'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'minor'
            }
        ]
    };

}


annotate schema.Booking {

    BookingStatus @Common.ValueListWithFixedValues;

    to_Customer   @Common.ValueList: {
        CollectionPath: 'Passenger',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Customer_CustomerID,
                ValueListProperty: 'CustomerID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'FirstName'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'LastName'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Title'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Street'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PostalCode'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'City'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CountryCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PhoneNumber'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'EMailAddress'
            }
        ]
    };

    to_Carrier    @Common.ValueList: {
        CollectionPath: 'Airline',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Carrier_AirlineID,
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CurrencyCode_code'
            }
        ]
    };

    ConnectionID  @Common.ValueList: {
        CollectionPath              : 'Flight',
        Label                       : '',
        Parameters                  : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Carrier_AirlineID,
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: ConnectionID,
                ValueListProperty: 'ConnectionID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: FlightDate,
                ValueListProperty: 'FlightDate'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: FlightPrice,
                ValueListProperty: 'Price'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'CurrencyCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'to_Airline/Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PlaneType'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'MaximumSeats'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'OccupiedSeats'
            }
        ],
        PresentationVariantQualifier: 'SortOrderPV' // use presentation variant to sort by FlightDate desc
    };

    FlightDate    @Common.ValueList: {
        CollectionPath: 'Flight',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Carrier_AirlineID,
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: ConnectionID,
                ValueListProperty: 'ConnectionID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: FlightDate,
                ValueListProperty: 'FlightDate'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: FlightPrice,
                ValueListProperty: 'Price'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'CurrencyCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'to_Airline/Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'PlaneType'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'MaximumSeats'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'OccupiedSeats'
            }
        ]
    };

    CurrencyCode  @Common.ValueList: {
        CollectionPath: 'Currencies',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'descr'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'symbol'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'minor'
            }
        ]
    };

}


annotate schema.BookingSupplement {

    to_Supplement @Common.ValueList: {
        CollectionPath: 'Supplement',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: to_Supplement_SupplementID,
                ValueListProperty: 'SupplementID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Price,
                ValueListProperty: 'Price'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'CurrencyCode_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Description'
            }
        ]
    };

    CurrencyCode  @Common.ValueList: {
        CollectionPath: 'Currencies',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyCode_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'descr'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'symbol'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'minor'
            }
        ]
    };
}


annotate schema.Flight with @UI.PresentationVariant #SortOrderPV: { // used in ValueList for Bookings:ConnectionId above
SortOrder: [{
    Property  : FlightDate,
    Descending: true
}]} {
    AirlineID    @Common.ValueList                              : {
        CollectionPath: 'Airline',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: AirlineID,
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CurrencyCode'
            }
        ]
    };

    ConnectionID @Common.ValueList                              : {
        CollectionPath: 'FlightConnection',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: AirlineID,
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: ConnectionID,
                ValueListProperty: 'ConnectionID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'AirlineID_Text'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'DepartureAirport'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'DestinationAirport'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'DepartureTime'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'ArrivalTime'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Distance'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'DistanceUnit'
            }
        ]
    };
};


annotate schema.FlightConnection {

    AirlineID          @Common.ValueList: {
        CollectionPath: 'Airline',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: AirlineID,
                ValueListProperty: 'CarrierID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'AirlineID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CurrencyCode'
            }
        ]
    };

    DepartureAirport   @Common.ValueList: {
        CollectionPath: 'Airport',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: DepartureAirport_AirportID,
                ValueListProperty: 'Airport_ID'
            }, // here FK is required
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'AirportID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'City'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CountryCode'
            }
        ]
    };

    DestinationAirport @Common.ValueList: {
        CollectionPath: 'Airport',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: DestinationAirport_AirportID,
                ValueListProperty: 'Airport_ID'
            }, // here FK is required
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'AirportID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'City'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'CountryCode'
            }
        ]
    };

}


annotate schema.Passenger {

    CountryCode @Common.ValueList: {
        CollectionPath: 'Countries',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CountryCode_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'descr'
            }
        ]
    };

}


annotate schema.TravelAgency {

    CountryCode @Common.ValueList: {
        CollectionPath: 'Countries',
        Label         : '',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CountryCode_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'descr'
            }
        ]
    };

}
