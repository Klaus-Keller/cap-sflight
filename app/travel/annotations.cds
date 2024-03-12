using TravelService as service from '../../srv/travel-service';
annotate service.Travel with @(
    UI.SelectionFields : [
        TravelStatus_code,
    ]
);

