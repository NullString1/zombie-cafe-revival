.class final Lcom/capcom/zombiecafeandroid/t;
.super Landroid/os/AsyncTask;


# instance fields
.field private a:Ljava/lang/String;

.field private b:Ljava/lang/String;

.field private c:Landroid/content/SharedPreferences$Editor;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    iput-object p1, p0, Lcom/capcom/zombiecafeandroid/t;->a:Ljava/lang/String;

    iput-object p2, p0, Lcom/capcom/zombiecafeandroid/t;->b:Ljava/lang/String;

    const-string v0, "START SharedPrefsTaskString"

    iget-object v1, p0, Lcom/capcom/zombiecafeandroid/t;->a:Ljava/lang/String;

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method protected final varargs synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3

    const-string v0, "DO SharedPrefsTaskBool"

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Key="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/capcom/zombiecafeandroid/t;->a:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    sget-object v0, Lcom/capcom/zombiecafeandroid/ZombieCafeAndroid;->CCsettings:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iput-object v0, p0, Lcom/capcom/zombiecafeandroid/t;->c:Landroid/content/SharedPreferences$Editor;

    iget-object v0, p0, Lcom/capcom/zombiecafeandroid/t;->c:Landroid/content/SharedPreferences$Editor;

    iget-object v1, p0, Lcom/capcom/zombiecafeandroid/t;->a:Ljava/lang/String;

    iget-object v2, p0, Lcom/capcom/zombiecafeandroid/t;->b:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    iget-object v0, p0, Lcom/capcom/zombiecafeandroid/t;->c:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    const/4 v0, 0x0

    return-object v0
.end method
