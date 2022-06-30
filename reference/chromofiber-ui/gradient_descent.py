
class GradientDescent:
  Deactivation D
  public DeactivationDye DD = new DeactivationDye()
  public Activation A = new Activation()
  public Tester T = new Tester();
  BIG_FLOAT = A.BIG_FLOAT;

  def __init__(Deactivation D):
    self.D = D;
  
  def get_optimal_activation(Point3D from_color, Point3D to_color) :
    float t_0 = A.DISABLE_ACTIVATION ? 0: A.get_optimal_activation(false, D.WHITE, from_color, 0, false);
    if (A.debug_level >= 4):
      println("Opt activation ", from_color, " -> ", to_color, "\tt0=", t_0);

    return A.DISABLE_ACTIVATION ? A.MAX_ACT_TIME: A.get_optimal_activation(true, from_color, to_color, t_0, true);
  
  def get_optimal_activationdye(Point3D starting_dye_ratio, Point3D to_color, int round) :
      # Wes: first round should ensure that each channel is at 100%. set in first parameter.
      return A.DISABLE_ACTIVATION ? A.MAX_ACT_TIME: A.get_optimal_activation(round == 0? true: false, starting_dye_ratio, to_color, 0, true);
  
  def get_optimal_deactivationdye(Point3D starting_dye_ratio, Point3D to_color):
    
    # return T.bruteForceBestTime(to_color.subtract(from_color));
    t_rgb = DD.get_optimal_deactivation(starting_dye_ratio, to_color);
    # //if (starting_dye_ratio.is_close(new Point3D(0.3,0.5, 0), 0.07)) {
      
    # //if (to_color.is_close(new Point3D(0, 255, 0), 1)) {
    # //          println("DEACT DYE:", starting_dye_ratio.to1DeciString(), ":::", to_color, t_rgb);
    # //      }
    return t_rgb
  
  Point3D get_optimal_deactivation(Point3D from_color, Point3D to_color):
    # return T.bruteForceBestTime(to_color.subtract(from_color));
    return D.get_optimal_deactivation(from_color, to_color);
