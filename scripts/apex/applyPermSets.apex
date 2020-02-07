/*
* Brute force script to apply all listed permission sets to all users
* who are part of the listed profiles
* Called from sfdx command line - eg: sfdx force:apex:execute -f scripts/applyPermSets.apex -u SDO
*/
List<String> permSetNames = new List<String>();
List<String> profileNames = new List<String>();
List<ID>permSetIDs = new List<ID>();
List<ID>profileIDs = new List<ID>();

Map<String, List<ID>> usersPerProfile = new Map<String, List<ID>>();
List<PermissionSetAssignment> permSetAssignments = new List<PermissionSetAssignment>();

/*
 * MAKE YOUR CHANGES BELOW - PUT IN YOUR DESIRED PERM SETS AND PROFILES
*/
//List of permission sets to apply
permSetNames.add('tth_Loyalty_Data_Model');
permSetNames.add('tth_BookingReservation_Data_Model');
permSetNames.add('tth_Reservation_Hospitality_Fields');
permSetNames.add('tth_Reservation_Airline_Fields');
permSetNames.add('tth_Traveler_Record');
permSetNames.add('tth_Rental_Preference_fields');
permSetNames.add('tth_Hospitality_Preference_fields');
permSetNames.add('tth_Airline_Preference_fields');
permSetNames.add('TTH_SDO_Tools_Extensions');
permSetNames.add('tth_Customer_360_Features');

//List of Profiles to apply all above perm sets to
profileNames.add('System Administrator');
/*
 * ----- DON'T TOUCH ANYTHING BELOW THIS OR YOU'LL BREAK SOMETHING -----
*/


//create mapping of all permSetIds
for (String curPermSetName : permSetNames) {

  try {
    PermissionSet permSet = [SELECT id FROM PermissionSet WHERE Name =: curPermSetName ];
      permSetIDs.add(permSet.ID);
        //System.debug('*** Added permset ' + curPermSetName + ' to map with ID ' + permSet.ID);
  } catch (Exception ex) {
      //System.debug('ORG MISSING PERMSET: ' + curPermSetName);
  }
}

//create mapping of all Profile IDs
for(String curProfileName : profileNames) {
  Profile curProfile = [SELECT id FROM Profile WHERE name =: curProfileName];
  profileIDs.add(curProfile.id);
  //System.debug('*** Added Profile ' + curProfileName + ' to profile map with ID ' + curProfile.id);
}

// Get all users who are part of a Profile
//Apply each permset to each of them - loop to next profile
for(ID curProfileID : profileIDs) {
  List<User> users = [SELECT id FROM User WHERE ProfileId =: curProfileID AND IsActive = true];

  //Create a perm set assignment for each of the people for each of the perm sets
  PermissionSetAssignment psa;
  for(User curUser : users){
    for(ID curPermSetID : permSetIDs) {
        psa = new PermissionSetAssignment
        (PermissionSetId = curPermSetID, AssigneeId = curUser.ID);
        permSetAssignments.add(psa);
        //System.debug('Permset ID ' + curPermSetID + ' to user: ' + curUser.ID);
    }
  }
}

System.debug('*** applyPermSets Script -- About to add ' + permSetAssignments.size() + ' permset assignments');
Database.insert(permSetAssignments,false);
