using UnityEngine;
public class SeqAnimateMgr : MonoBehaviour
{
	public SeqAnimateTexture seqAnimateTexture;
    public int count = 10;

    void Start()
    {
        System.Random rnd = new System.Random();
        GameObject asset = seqAnimateTexture.gameObject; // 在Inspector窗口中拖入你的敌人预制体
        for (int i = 0; i < count; i++) {
            GameObject obj = Instantiate(asset, transform.parent);
            obj.name = "SeqAnimateTexture_" + i;

            Vector3 pos = new Vector3(rnd.Next(-100, 100), rnd.Next(-150, 150), 0);
            obj.transform.localPosition = pos;
            obj.transform.localRotation = Quaternion.identity;
            obj.transform.localScale = Vector3.one * 0.3f;
        }
	}
}