FROM node:10.5-alpine

# 安装 nodejs 的模块：gitbook 命令行
RUN npm config set unsafe-perm true
RUN npm install gitbook-cli -g
# Gitbook 插件：自动生成 summary.md 文件内容
RUN npm install gitbook-plugin-summary

# 获取 gitbook 的官方版本并安装
# 通过 gitbook ls-remote 可以列举额 npm 上可以安装的版本号
# 但是不建议使用 3.2.3 之后的版本，官方为了收费反而阉割了不少功能
ARG GITBOOK_VERSION=3.2.3
RUN gitbook fetch $GITBOOK_VERSION

# 定义 Docker 数据卷位置 /gitbook 
ENV BOOKDIR /gitbook

# 检查并创建 /gitbook 目录
RUN if [ ! -d "$BOOKDIR" ]; then mkdir -p "$BOOKDIR"; fi

COPY ./gitbook/* $BOOKDIR/

RUN cd $BOOKDIR && gitbook install

VOLUME $BOOKDIR

# 暴露 4000 端口 （gitbook 默认的服务端口）
EXPOSE 4000

# 定义工作目录为 /gitbook
WORKDIR $BOOKDIR

# 安装完成后运行服务
CMD ["gitbook", "help"]

