<script>
import { watch, onMounted, reactive, ref } from "vue";

export default {
  setup() {
    /// obj= {    name:"name" , type: txt / file   ,  layer:層      ,children:[ ]   }

    const state = reactive({
      files: [
        { file: { name: "1" } },
        [{ file: { name: "2" } }, { file: { name: "3" } }],
        [
          [[{ file: { name: "4" } }], { file: { name: "5" } }],
          { file: { name: "6" } },
          [[{ file: { name: "7" } }]],
        ],
      ],
    });

    const reState = reactive({ files: [] });
    const active = ref();
    const inputText = ref("");

    watch(reState, () => {
      reState.files.forEach((item, index) => {
        item.ID = index;

        if (item.isShow == null) {
          item.isShow = false;
          if (item.layer == "a") {
            item.isShow = true;
          }
        }
        // console.log(item);
      });
    });
    // 階層樣式
    const layer = ["a", "b", "c", "d", "e", "f"];


    // 新增檔案
    const addText = () => {
      let getID = active.value.getAttribute("id");
      let inputSplit = inputText.value.split(".");
      let inputName = inputSplit[0];
      if (Array.isArray(inputSplit) === true) {
        let inputType = inputSplit[1];
        if (inputType === undefined) {
          inputName = "資料夾";
          if (getID != undefined) {
            reState.files.forEach((item, index) => {
              if (item.ID == getID) {
                let obj = { file: { name: inputName } };
                reState.files.splice(index + 1, 0, obj);
              }
              inputText.value = "";
            });
          } else {
            alert("選擇路徑");
          }
        } else if (inputSplit.length > 2) {
          alert("輸入格式錯誤");
        } else {
          if (getID != undefined) {
            reState.files.forEach((item, index) => {
              if (item.ID == getID) {
                let obj = { file: { name: inputName } };
                reState.files.splice(index + 1, 0, obj);
              }
              inputText.value = "";
            });
          } else {
            alert("選擇路徑");
          }
        }
      }
    };
    const handShow = () => {};

    //新增點選樣式 /移除舊的
    addEventListener("click", (e) => {
      let input = document.querySelector("input");

      //目前點選的
      let target = e.target;
      //上一個被點選的
      let actived = document.querySelector(".active");
      ///
      //如果沒點input 移除舊的
      if (target != input) {
        //檢查是否點擊的是dom li
        if (target.tagName === "LI") {
          if (actived !== null) {
            actived.classList.toggle("active");
          }
          target.classList.toggle("active");

          let getID = target.getAttribute("id");

          reState.files.forEach((item) => {
            if (item.ID == getID) {
              // 抓到 id了 => 換當層layer => 如果是資料夾 => 下層layer的item.isShow 開關
              //
              console.log(item.isShow);
              console.log(item.layer);

              // item.isShow = true;
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
    let layerIdx = 0;

    const isArr = (item, idx) => {
      item.forEach((item) => {
        itemCheckArr(item, idx);
      });
    };

    const itemCheckArr = (item, idx) => {
      if (Array.isArray(item) === true) {
        reState.files.push({ file: { name: "資料夾" }, layer: layer[idx] });
        idx++;
        isArr(item, idx);
      } else {
        item.layer = layer[idx];
        reState.files.push(item);
        // return;
      }
    };
    // --------------------------------------------------階層展開)
    onMounted(() => {
      isArr(state.files, layerIdx);
    });

    return {
      inputText,
      reState,
      state,
      addText,
    };
  },
};
</script>
<template>
  <div class="side">
    <div class="header">
      <h1>檔案總管</h1>
    </div>
    <hr />
    <input type="text" @keyup.enter="addText" v-model="inputText" />
    <br />
    <ul>
      <li
        v-for="(item, index) in reState.files"
        :key="index"
        :class="item.layer"
        :id="index"
      >
        <!-- v-show="item.isShow" -->
        <input type="checkbox" v-show="item.file.name == '資料夾'" />
        {{ item.file.name }} - 層:{{ item.layer }}
      </li>
    </ul>
  </div>

  <!-- <div class="aside">
    <ul></ul>
  </div> -->
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
.side {
  width: 80%;
  display: flex;
  flex-direction: column;
  align-items: center;
  .header {
    text-align: center;
    width: 100%;
    height: 100px;
  }
}
.aside {
  border: 5px solid red;
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
