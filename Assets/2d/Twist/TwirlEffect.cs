using UnityEngine;
using System.Collections;


public class TwirlEffect : MonoBehaviour {
    public Shader shader;
    public float    angle = 50;
    public Vector2  radius = new Vector2(0.3F,0.3F);
    public Vector2  center = new Vector2 (0.5F, 0.5F);
    private Material mat;


    void Start()
    {
        mat = new Material(shader);
    }


	/*
	OnRenderImage is called after all rendering is complete to render image, postprocessing effects (Unity Pro only).
	It allows you to modify final image by processing it with shader based filters. The incoming image is source render texture. The result should end up in destinationrender texture. When there are multiple image filters attached to the camera, they process image sequentially, by passing first filter's destination as the source to the next filter.
	This message is sent to all scripts ***attached to the camera***.
	*/
    void OnRenderImage (RenderTexture source, RenderTexture destination)
    {
        RenderDistortion (mat, source, destination, angle, center, radius);
    }


    public static void RenderDistortion(Material material, RenderTexture source, RenderTexture destination, float angle, Vector2 center, Vector2 radius)
    {
        Matrix4x4 rotationMatrix = Matrix4x4.TRS(Vector3.zero, Quaternion.Euler(0 , 0 , angle), Vector3.one);
        material.SetMatrix("_RotationMatrix", rotationMatrix);
        material.SetVector("_CenterRadius", new Vector4(center.x, center.y, radius.x, radius.y));
        Graphics.Blit(source, destination, material);
    }
}