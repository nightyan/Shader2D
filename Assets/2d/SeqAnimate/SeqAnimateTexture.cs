using UnityEngine;

public class SeqAnimateTexture : MonoBehaviour
{
    public UITexture uiTexture;
    public float speed = 100f;
    public int rows = 3;
    public int cols = 4;
    public int frameCount = 12;

    private float randomSeed;
    private Material originalMaterial;
    private Material instanceMaterial;

    void Start()
    {
        if (uiTexture == null)
            uiTexture = GetComponent<UITexture>();

        randomSeed = Random.Range(0f, 1000f);

        // 创建材质实例
        if (uiTexture != null && uiTexture.material != null) {
            originalMaterial = uiTexture.material;
            instanceMaterial = new Material(originalMaterial);
            uiTexture.material = instanceMaterial;
        }
    }

    void Update()
    {
        if (instanceMaterial != null) {
            // 设置材质属性
            float uniqueTime = Time.time + randomSeed;
            float index = Mathf.Floor(uniqueTime * speed) % frameCount;

            instanceMaterial.SetFloat("_RandomSeed", randomSeed);
            instanceMaterial.SetFloat("_TimeOffset", uniqueTime);

            // 或者直接计算UV偏移并设置
            //UpdateTextureUV(index);
        }
    }

    void UpdateTextureUV(float frameIndex)
    {
        float indexY = Mathf.Floor(frameIndex / cols);
        float indexX = frameIndex - indexY * cols;

        float scaleX = 1f / cols;
        float scaleY = 1f / rows;
        float offsetX = indexX / cols;
        float offsetY = 1f - (indexY + 1) / rows; // NGUI的UV坐标系可能不同

        if (uiTexture != null) {
            uiTexture.uvRect = new Rect(offsetX, offsetY, scaleX, scaleY);
        }
    }

    void OnDestroy()
    {
        // 恢复原始材质
        if (uiTexture != null && originalMaterial != null) {
            uiTexture.material = originalMaterial;
        }

        if (instanceMaterial != null) {
            DestroyImmediate(instanceMaterial);
        }
    }
}