using UnityEngine;
using System.Collections;
public class BlurManager : MonoBehaviour {
    private float length = 3f;
    private float clearTime = -100;
    private float blurTime = -100;
    
    void Update () {
        if(clearTime >0)
        {
            clearTime -= Time.deltaTime;
            Shader.SetGlobalFloat("uvOffset", (clearTime/length) * 0.005f);
        }
       
        if(blurTime >0)
        {
            blurTime -= Time.deltaTime;
            Shader.SetGlobalFloat("uvOffset", (1- blurTime/length) * 0.005f);
        }
    }
   
    void OnGUI()
    {
        if(GUI.Button(new Rect(0,0,100,50), "Clear"))
        {
            clearTime = length;
        }
       
        if(GUI.Button(new Rect(100,0,100,50), "Blur"))
        {
            blurTime = length;
        }
    }
}