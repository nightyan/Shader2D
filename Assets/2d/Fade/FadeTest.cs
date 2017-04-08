using UnityEngine;
using System.Collections;

public class FadeTest : MonoBehaviour {
	public Transform obj;
	public float speed = 0.1f;

	public float near = 0.0f;
	public float far = 10.0f;


	// Use this for initialization
	void Start () {
	
	}
	

	// Update is called once per frame
	void Update () {
		Vector3 pos = obj.localPosition;
		pos.z += speed;
		if (speed > 0 && pos.z > far || speed < 0 && pos.z < near)
			speed *= -1;
		obj.localPosition = pos;
	}
}
