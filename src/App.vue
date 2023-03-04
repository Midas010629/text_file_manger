<script>
import { watch, onMounted, reactive, ref } from "vue";

export default {
  setup() {
    /// 預設的file = {    name:"name" , type: txt / file      ,children:[ ]      ID / layer }
    class file {
      constructor(name, children) {
        this.name = name;

        this.children = children;
      }
    }

    //  const  obj = (name, type, children) => new file(name, type, children);
    let test = new file("obj", []);

    let obj1 = new file("obj1", []);
    let obj2 = new file("obj2", []);
    let obj3 = new file("obj3", []);
    let obj4 = new file("obj4", []);
    let obj5 = new file("obj5", []);
    let obj6 = new file("obj6", []);
    let obj7 = new file("obj7", []);
    let file1 = new file("資料夾1", [obj2, obj3]);
    let file5 = new file("資料夾5", [obj4]);
    let file6 = new file("資料夾6", [obj7]);
    let file3 = new file("資料夾3", [file5, obj5]);
    let file4 = new file("資料夾4", [file6]);
    let file2 = new file("資料夾2", [file3, obj6, file4]);

    const state = reactive({
      files: [obj1, file1, file2],
    });

    // state展開
    const reState = reactive({ files: [] });
    // 點擊
    const active = ref();

    // 階層樣式 test
    const layer = ["a", "b", "c", "d", "e", "f ", "g"];

    const addFileList = reactive({ id: "", layer: "" });
    const inputText = ref("");

    watch(reState, () => {
      reState.files.forEach((item, index) => {
        item.ID = index;
        if (item.isShow == null) {
          item.isShow = true;
        }
      });
    });

    // 新增檔案///
    const addFile = () => {
      let getID = active.value.getAttribute("id");

      if (getID != undefined) {
        let inputSplit = inputText.value.split(".");
        let inputName = inputSplit[0];
        if (Array.isArray(inputSplit) === true) {
          let inputType = inputSplit[1];
          // 如果是資料夾
          if (inputType === undefined) {
            inputName = `資料夾-${inputName}`;
            let obj = {
              name: inputName,
              type: "file",
              layer: addFileList.layer,
            };
            reState.files.splice(addFileList.id + 1, 0, obj);

            inputText.value = "";
          } else if (inputSplit.length > 2) {
            alert("輸入格式錯誤");
          }
          // 執行檔 type: inputType
          else {
            if (getID != undefined) {
              let obj = {
                name: inputName,
                type: "txt",
                layer: addFileList.layer,
              };
              reState.files.splice(addFileList.id + 1, 0, obj);

              inputText.value = "";
            }
          }
        }
      } else {
        alert("選擇路徑");
      }
    };

    //新增點選樣式 /移除舊的
    addEventListener("click", (e) => {
      let input = document.querySelector("input");
      //目前點選的
      let target = e.target;
      //上一個被點選的
      let actived = document.querySelector(".active");
      ///
      //如果沒點input移除舊的 / 舊的不能為空
      if (target != input) {
        if (actived !== null) {
          actived.classList.toggle("active");
        }
        target.classList.toggle("active");

        //檢查是否點擊的是 li
        let getID = target.getAttribute("id");

        if (target.tagName === "LI") {
          reState.files.forEach((item) => {
            // 抓 id
            if (item.ID == getID) {
              // 丟file 到當層layer ,如果是資料夾 => 下層layer
              addFileList.id = item.ID;
              addFileList.layer = item.layer;
              if (item.type === "file") {
                let idx = layer.indexOf(addFileList.layer);
                addFileList.layer = layer[idx + 1];
              }
            }
          });
        }
        // 檢查是否點擊的是  checkbox
        else if (target.parentElement.tagName === "LI") {
          let getID = target.parentElement.getAttribute("id");
          reState.files.forEach((item, index) => {
            // 抓 id
            if (item.ID == getID) {
              // startIndex 為子目錄 起始的index
              let startIndex = index + 1;
              // endIndex 為子目錄 結束的index
              let endIndex = null;

              // subLayer 為判斷子層的依據
              let subLayer = item.layer;
              let subArray = reState.files.slice(startIndex);

              // 判斷子目錄有無資料
              if (layer.indexOf(subLayer) < layer.indexOf(subArray[0].layer)) {
                let getIndex = subArray.findIndex(
                  (item) => item.layer === subLayer
                );
                if (getIndex === -1) {
                  endIndex = reState.files.length - 1;
                } else {
                  endIndex = startIndex + getIndex - 1;
                }
                // 判斷是要開啟 或 關閉
                if (target.checked == false) {
                  //開
                  console.log("open");
                  let changeArr = reState.files.slice(startIndex, endIndex + 1);
                  // console.log(changeArr);
                  changeArr.forEach((item) => {
                    // 開啟同層的資料
                    if (item.layer == subArray[0].layer) {
                      item.isShow = true;
                    }
                  });
                } else {
                  console.log("close");
                  let changeArr = reState.files.slice(startIndex, endIndex + 1);
                  // console.log(changeArr);
                  changeArr.forEach((item) => {
                    item.isShow = false;
                  });
                }
              } else {
                console.log("無資料");
              }
            }
          });
        }

        active.value = target;

        // console.log(target);
        // console.log("------------");
        // console.log(reState.files);
      }
    });

    // --------------------(階層展開-----------------
    let layerBase = 0;

    const loadFile = (item, idx) => {
      item.forEach((item) => {
        checkChildren(item, idx);
      });
    };

    const checkChildren = (item, idx) => {
      item.layer = layer[idx];
      reState.files.push(item);
      // children 有資料
      if (item.children.length != 0) {
        item.type = "file";
        idx++;
        loadFile(item.children, idx);
      } else {
        item.type = "txt";
      }
    };
    // --------------------------------------------------階層展開)
    onMounted(() => {
      loadFile(state.files, layerBase);
    });

    return {
      inputText,
      reState,
      state,
      addFile,
    };
  },
};
</script>
<template>
  <div class="main">
    <div class="header">
      <h1>檔案總管</h1>
    </div>
    <div class="content">
      <input type="text" @keyup.enter="addFile" v-model="inputText" />
      <ul>
        <li
          v-for="(item, index) in reState.files"
          :key="item.ID"
          :class="item.layer"
          :id="item.ID"
          v-show="item.isShow"
        >
          <input type="checkbox" v-show="item.type == 'file'" value="false" />
          {{ item.ID }}***{{ item.name }} :::{{ item.layer }}
        </li>
      </ul>
    </div>
    <div class="footer">search</div>
  </div>

  <div class="aside">nav</div>
</template>

<style lang="scss">
* {
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}
html,
body {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: slategray;
}
input {
  border: 2px solid black;
}
ul {
  display: flex;
  flex-direction: column;
  li {
    &.active {
      color: red;
      background-color: white;
    }
  }

  .a {
  }
  .b {
    padding-left: 100px;
  }
  .c {
    padding-left: 200px;
  }
  .d {
    padding-left: 300px;
  }
}

#app {
  display: flex;
  flex-direction: row-reverse;
  width: 100%;
  height: 100%;
}
.main {
  width: 80%;
  display: flex;
  flex-direction: column;
  align-items: center;

  .header {
    width: 100%;
    border: 2px solid red;
    text-align: center;
  }
  .content {
    width: 100%;
    flex: auto;
    border: 2px solid red;
  }
  .footer {
    width: 100%;
    height: 20%;
    border: 2px solid blue;
    text-align: center;
  }
}
.aside {
  border: 2px solid red;
  width: 20%;
}
</style>
<!-- 
nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
} -->
