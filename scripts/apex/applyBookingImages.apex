/*
  1) list of Hotel bookings
  2) List of Economy Flight bookings
  3) List of Business/First Class flight bookings

  ContentDocumentVersion -> ContentDocument -> ContentDocumentLink (ContentDocumentID and LinkedEntityId)
*/

List<tth_Booking__c> hotelBookings;
List<tth_Booking__c> econFlights;
List<tth_Booking__c> firstClassFlights;
Map<String, ContentDocument> images;

List<String> stdHotelRoomImageNames = new List<String> {'Bathroom1','Gym1','Pool1','Room1','Room2','Room3'};
List<String> firstClassFlightImageNames = new List<String> {'BusinessSeat1','BusinessSeat2','BusinessSeat3'};
List<String> econFlightImageNames = new List<String> { 'EconomySeat1','EconomySeat2','EconomySeat3','EconomySeat4'};
List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();

//Load Hotel Bookings
try {
  hotelBookings = [select ID from tth_booking__c where tth_Booking_Type__c = 'Hotel'];
} catch (Exception ex){
  hotelBookings = null;
  System.debug('No hotel bookings found');
}

//Load Economy Flights
try {
  econFlights  = [select ID from tth_booking__c where tth_Booking_Type__c = 'Flight' AND (tth_Travel_Class__c = 'Economy' OR tth_Travel_Class__c ='Premium Economy')];
} catch (Exception ex){
  econFlights = null;
  System.debug('No economy class flight bookings found');
}

//Load First Class Flights
try {
  firstClassFlights = [select ID from tth_booking__c where tth_Booking_Type__c = 'Flight' AND (tth_Travel_Class__c = 'Business' OR tth_Travel_Class__c = 'First')];
} catch (Exception ex){
  firstClassFlights = null;
  System.debug('No first class flight bookings found');
}

//Create ContentDocument Map
try {
  List<ContentDocument> contentDocList = [SELECT ID, Title FROM ContentDocument WHERE Title in :stdHotelRoomImageNames OR Title in :econFlightImageNames OR Title in :firstClassFlightImageNames];
  images = new Map<String, ContentDocument>();

  for(ContentDocument curRec : contentDocList) {
    System.debug('Putting image into map with title: ' + curRec.Title);
    images.put(curRec.Title, curRec);
  }
} catch (Exception ex){
  System.debug('Could not load list of content documents');
  images = null;
}

if (hotelBookings != null) {
  for (tth_Booking__c curBooking : hotelBookings) {
    for(String curImageName : stdHotelRoomImageNames){
        ContentDocument contentDoc = (ContentDocument)images.get(curImageName);
        docLinks.add( new ContentDocumentLink(ContentDocumentID=contentDoc.ID , LinkedEntityId=curBooking.ID, ShareType='V') );
    }
  }
}

if (econFlights != null) {
  for (tth_Booking__c curBooking : econFlights) {
    for(String curImageName : econFlightImageNames){
        ContentDocument contentDoc = (ContentDocument)images.get(curImageName);
        docLinks.add( new ContentDocumentLink(ContentDocumentID=contentDoc.ID , LinkedEntityId=curBooking.ID, ShareType='V') );
    }
  }
}

if (firstClassFlights != null) {
  for (tth_Booking__c curBooking : firstClassFlights) {
    for(String curImageName : firstClassFlightImageNames){
        ContentDocument contentDoc = (ContentDocument)images.get(curImageName);
        docLinks.add( new ContentDocumentLink(ContentDocumentID=contentDoc.ID , LinkedEntityId=curBooking.ID, ShareType='V') );
    }
  }
}

System.debug('About to create ' + docLinks.size() + ' links between bookings and images...');
Database.insert(docLinks, false);
