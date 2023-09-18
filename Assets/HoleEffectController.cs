using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class HoleEffectController : MonoBehaviour
{
    private Renderer rend;
    public Transform cube; 
    private static readonly int HoleCenter = Shader.PropertyToID("_HoleCenter");
    private static readonly int HoleRadius = Shader.PropertyToID("_HoleRadius");

    public float holeSizeFactor = 1.5f; 

    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    void Update()
    {
        if (cube)
        {
            rend.material.SetVector(HoleCenter, cube.position);

            var scale = cube.localScale;
            float significantDimension = scale.y > scale.z ? cube.localScale.y : cube.localScale.z;
            float holeRadius = significantDimension * holeSizeFactor;
            rend.material.SetFloat(HoleRadius, holeRadius);
        }
    }
}