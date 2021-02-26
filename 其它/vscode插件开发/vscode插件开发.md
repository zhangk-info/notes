### 本文主要简单介绍我自己在vscode插件开发时候的过程
#### 本文主要实现通过vscode插件操作工作空间的文件
### 先贴上自己改动过的代码
- **extension.js**
```
##################引入两个组件####################
const path = require('path');
const workspace = vscode.workspace;

##################更改activate####################
/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {

	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('Congratulations, your extension "xxx" is now active!');

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with  registerCommand
	// The commandId parameter must match the command field in package.json
	let disposable = vscode.commands.registerCommand('xxx.helloWorld', function () {
		// The code you place here will be executed every time your command is executed

		// Display a message box to the user
		const message = 'Hello World from xxx!';
		vscode.window.showInformationMessage(message);
	});

	context.subscriptions.push(disposable);

	//初始化树形
	CourseTreeProvider_1.MyTreeProvider.initMyTreeList();

	//添加一个网页浏览器
	context.subscriptions.push(
		vscode.commands.registerCommand('xxx.generate', () => {
			let workspacePath = workspace.rootPath;
			if(workspacePath == undefined){
				vscode.window.showInformationMessage("没有打开任何工作空间");
			}
			let panel = vscode.window.createWebviewPanel(
				'generate',
				'generate Coding',
				vscode.ViewColumn.One,
				{
					// Only allow the webview to access resources in our extension's media directory
					localResourceRoots: [vscode.Uri.file(
						path.join(workspacePath)
					)],
					// Enable scripts in the webview
					enableScripts: true
				}	
			);
			

			console.log(workspacePath)
			let onDiskPath = vscode.Uri.file(
				path.join(workspacePath, 'images', '**.png')
			);
			let catSrc = panel.webview.asWebviewUri(onDiskPath);

			panel.webview.html = getWebviewContent(catSrc);

			// Handle messages from the webview
			panel.webview.onDidReceiveMessage(
				message => {
					switch (message.command) {
						case 'alert':
							vscode.window.showErrorMessage(message.text);
							return;
						case 'download':
							let writePath = vscode.Uri.file(
								path.join(workspacePath, 'testWrite', 'test.js')
							);
							let content = new Uint8Array(stringToByte(message.text));
							workspace.fs.writeFile(writePath,content);
							return;
						case 'create':
							let createPath = vscode.Uri.file(
								path.join(workspacePath, 'testWrite', 'test-create.js')
							);
							let createContent = new Uint8Array(stringToByte(message.text));
							vscode.window.showInformationMessage(message.text);
							workspace.fs.writeFile(createPath,createContent);
							return;
					}
				},
				undefined,
				context.subscriptions
			);
		})
	);
}

##################增加getWebviewContent####################

function getWebviewContent(catSrc) {
	return `
<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Cat Coding</title>
	</head>
	<body>
		<img src="${catSrc}" width="300" />
		<h1 id="lines-of-code-counter">0</h1>
		<button onclick="testMessage();">测试消息传递</button>
		<button onclick="testFileWrite();">测试写文件</button>
		<br />
		<input type="text" id="test-file-create" />
		<button onclick="testFileCreate();">测试文件创建</button>
	</body>
	<script>
		const vscode = acquireVsCodeApi();

		// Alert the extension when our cat introduces a bug
		let testMessage = function(){
			vscode.postMessage({
				command: 'alert',
				text: '🐛🐛🐛🐛🐛🐛'
			})
		}

		let testFileWrite = function(){
			vscode.postMessage({
				command: 'download',
				text: '测试写文件，文件内容！！！'
			})
		}

		let testFileCreate = function(){
			vscode.postMessage({
				command: 'create',
				text: document.getElementById('test-file-create').value
			})
		}

		const counter = document.getElementById('lines-of-code-counter');
		let count = 0;
		setInterval(() => {
            counter.textContent = count++;
		}, 100);
		
	</script>
</html>
  `;
}

```
  
- **修改package.json**

 ```
{
	"name": "xxx",
	"displayName": "xxx",
	"description": "测试html同工作区间文件交互",
	"version": "0.0.1",
	"engines": {
		"vscode": "^1.46.0"
	},
	"categories": [
		"Other"
	],
	"activationEvents": [
		"*"
	],
	"main": "./extension.js",
	"publisher": "test",
	"contributes": {
		"commands": [
			{
				"command": "xxx.helloWorld",
				"title": "test-Hello World"
			},
			{
				"command": "xxx.generate",
				"title": "test-generate"
			}
		]
	},
	"scripts": {
		"lint": "eslint .",
		"pretest": "npm run lint",
		"test": "node ./test/runTest.js"
	},
	"devDependencies": {
		"@types/vscode": "^1.46.0",
		"@types/glob": "^7.1.1",
		"@types/mocha": "^7.0.2",
		"@types/node": "^13.11.0",
		"eslint": "^6.8.0",
		"glob": "^7.1.6",
		"mocha": "^7.1.2",
		"typescript": "^3.8.3",
		"vscode-test": "^1.3.0"
	}
}
```

### 然后再来说写代码之前和之后干的事情
1. 环境搭建 = 项目搭建
看官方就对了：
[https://code.visualstudio.com/api/get-started/your-first-extension](https://code.visualstudio.com/api/get-started/your-first-extension)
- npm install -g yo generator-code
- yo code
2. 怎么测试 
- f5运行
- vscode会打开新窗口
- 新窗口中打开一个工作空间
- Run the Hello World command from the Command Palette (Ctrl+Shift+P) in the new window: ctrl + shift + p 打开命令框
- 搜索命令 xxx.helloWord 或者命令 xxx.generate
- 运行
3. 测试失败处理
- 重启打开的新窗口
ctrl + shift + p 打开命令框
搜索命令 reload window
- generate运行之后测试不通过，打开网页调试，查看网页是否报错
ctrl + shift + p 打开命令框
搜索命令![image.png](https://upload-images.jianshu.io/upload_images/22102029-ce2a28d017c65e7a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

