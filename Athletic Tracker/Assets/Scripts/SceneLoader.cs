using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class SceneLoader : MonoBehaviour
{
    private int currentScene;
    private int previousScene;

    private void Awake()
    {
        int amount = FindObjectsOfType<SceneLoader>().Length;
        if (amount > 1)
        {
            gameObject.SetActive(false);
            Destroy(gameObject);
        }
        else
        {
            DontDestroyOnLoad(gameObject);
        }
    }
    public void LoadNextScene()
    {
        previousScene = BuildSceneIndex();
        int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
        SceneManager.LoadScene(currentSceneIndex + 1);
        currentScene = BuildSceneIndex();
    }
    public void Home()
    {
        previousScene = BuildSceneIndex();
        SceneManager.LoadScene("Home");
        currentScene = BuildSceneIndex();
    }
    public void Help()
    {
        previousScene = BuildSceneIndex();
        SceneManager.LoadScene("Help");
        currentScene = BuildSceneIndex();
    }
    public void Quit()
    {
        Application.Quit();
    }
    public int BuildSceneIndex()
    {
        int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
        return currentSceneIndex;
    }
    public void Back()
    {
        previousScene = BuildSceneIndex();
        SceneManager.LoadScene(previousScene);
        currentScene = BuildSceneIndex();
    }
    public void SetScene(string name)
    {
        previousScene = BuildSceneIndex();
        SceneManager.LoadScene(name);
        currentScene = BuildSceneIndex();
    }
    public void SetScene(int sceneIndex)
    {
        previousScene = BuildSceneIndex();
        SceneManager.LoadScene(sceneIndex);
        currentScene = BuildSceneIndex();
    }
}
