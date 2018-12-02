class DonutSection
{
  static final float NOISE_SCALE = 0.005f;
  float quantity;
  
  float hueParameter;
  final float saturationParameter;
  final float brightnessParameter;
  
  float seed;
  
  DonutSection(float huePrm)
  {
    setHue(random(huePrm - 5f, huePrm + 5f));
    
    switch(int(random(10f)))
    {
      case 0:
      case 1:
      case 2:
        saturationParameter = 0f;
        brightnessParameter = 100f;
        break;
      case 3:
        addHue(50f);
      default:
        saturationParameter = 70f;
        brightnessParameter = 90f;
        break;
    }
    
    seed = random(0f, 100f);
  }
  
  color getColor()
  {
    colorMode(HSB, 100f);
    return color(hueParameter, saturationParameter, brightnessParameter);
  }
  
  float getQuantity()
  {
    return quantity;
  }
  
  float getArcAngle(float totalQuantity)
  {
    return TWO_PI * quantity / totalQuantity;
  }
  
  void setHue(float huePrm)
  {
    hueParameter = (huePrm % 100 + 100) % 100;
  }
  
  void addHue(float hueDistance)
  {
    setHue(hueParameter + hueDistance);
  }
  
  void reflect(float x, float y)
  {
    quantity = noise(seed + x * NOISE_SCALE, y * NOISE_SCALE);
    quantity = pow(quantity, 3);
  }
  
  void update()
  {
    addHue(0.1f);
  }
}
