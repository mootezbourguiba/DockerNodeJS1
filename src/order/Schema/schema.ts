import { Schema as MongooseSchema } from 'mongoose';
import { Schema, Prop, SchemaFactory } from '@nestjs/mongoose';

export type OrderDocument = Order & Document;
@Schema()
export class Order {
  @Prop({ required: true })
  utilisateur: string;
  @Prop({ required: true })
  produit: string;
  @Prop({ required: true })
  quantite: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
