--contenuto della risoluzione della applicazione 


local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
    content = {
      width = aspectRatio > 1.5 and 1080 or math.ceil( 1920 / aspectRatio ),
      height = aspectRatio < 1.5 and 1920 or math.ceil( 1080 * aspectRatio ),
      scale = "letterBox",
      fps = 60,

      imageSuffix = {
         ["@2"] = 1.5,
         ["@4"] = 3.6,
      },
   },
}
