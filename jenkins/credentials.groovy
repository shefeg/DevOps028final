import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,java.util.UUID.randomUUID().toString(), "description", "admin", "hALEUMyU2cujt3XfysPwuXCnElNbmKDD")

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)