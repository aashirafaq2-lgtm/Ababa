import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
import path from 'path';

const PROTO_PATH = path.resolve(__dirname, '../../../../contracts/protobuf');

export function createGrpcClient(serviceName: string, serviceAddr: string) {
    const packageDefinition = protoLoader.loadSync(
        path.join(PROTO_PATH, `${serviceName}.proto`),
        {
            keepCase: true,
            longs: String,
            enums: String,
            defaults: true,
            oneofs: true,
        }
    );

    const protoDescriptor = grpc.loadPackageDefinition(packageDefinition);
    // @ts-ignore
    const service = protoDescriptor.pb[serviceName.charAt(0).toUpperCase() + serviceName.slice(1) + 'Service'];

    return new service(serviceAddr, grpc.credentials.createInsecure());
}
