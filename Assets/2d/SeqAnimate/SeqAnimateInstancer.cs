using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeqAnimateInstancer : MonoBehaviour
{
    public Material sharedMaterial;
    public int instanceCount = 10;

    void Start()
    {
        MaterialPropertyBlock props = new MaterialPropertyBlock();
        Mesh mesh = GetComponent<MeshFilter>().mesh;

        for (int i = 0; i < instanceCount; i++) {
            GameObject obj = new GameObject("AnimatedSprite_" + i);
            obj.transform.SetParent(transform);

            // 添加MeshRenderer和MeshFilter
            MeshRenderer renderer = obj.AddComponent<MeshRenderer>();
            MeshFilter filter = obj.AddComponent<MeshFilter>();
            filter.mesh = mesh;

            // 设置材质属性块
            props.SetFloat("_RandomSeed", Random.Range(0f, 1000f));
            renderer.SetPropertyBlock(props);
            renderer.sharedMaterial = sharedMaterial;
        }
    }
}