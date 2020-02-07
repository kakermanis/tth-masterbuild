//Select all the Recommendations ID and Names
//Take the names, replace - and & with a space
//String.remove()
//String.deleteWhitespace()

//get ContentAsset ID of all assets with matching names
//update recommendation.imageID with mathcing content asset ID

// WHERE ImageID = null
List<Recommendation> recommendations = [SELECT ID, Name, ImageID from Recommendation WHERE ImageID = null];
Map<String,Recommendation> recommendationMap = new Map<String,Recommendation>();
List<String> fileNames = new List<String>();
List<ContentAsset> assetFiles;
List<Recommendation> recsToUpdate = new List<Recommendation>();

for(Recommendation curRec : recommendations) {
  String fileName;
  fileName = curRec.name.replaceAll('[^a-zA-Z0-9\\s+]', '').deleteWhitespace();
  System.debug('******* Recommendation ' + curRec.name + ' is missing an icon. Guessing at ContentAsset name of: ' + fileName);
  recommendationMap.put(fileName, curRec);
  fileNames.add(fileName);
}

if (!fileNames.isEmpty()) {
  System.debug('******* Searching for the following ContentAssets: ' + fileNames);
  assetFiles = [SELECT ID, DeveloperName FROM ContentAsset where DeveloperName in :fileNames];

  for(ContentAsset curContent : assetFiles) {
    Recommendation curRec = recommendationMap.get(curContent.DeveloperName);

    if(curRec != null) {
      curRec.imageId = curContent.ID;
      recsToUpdate.add(curRec);
    }
  }
}

if (!recsToUpdate.isEmpty()) {
  System.debug('Going to update ' + recsToUpdate.size() + ' Recommendations');
  Database.update(recsToUpdate);
}
